'use strict';

const crypto = require('node:crypto');
const { GoogleAuth } = require('google-auth-library');

const DEFAULT_MODEL = 'gemini-2.5-flash-lite';
const DEFAULT_LOCATION = 'us-central1';
// All embedded Itzli cloud inference from Cyberneom routes to `itzli-app` so
// Vertex AI token billing stays centralized on Itzli's billing account
// (01FF6D-B4A3CA-3BE0DB) instead of Cyberneom's account.
const DEFAULT_VERTEX_PROJECT_ID = 'itzli-app';

// Trusted web origins allowed to invoke embedded Itzli Cloud On-Demand as a
// rate-limited guest when Anonymous Auth is disabled on cyberneom-edd2d.
const ALLOWED_GUEST_ORIGINS = new Set([
  'https://cyberneom.xyz',
  'https://www.cyberneom.xyz',
  'https://cyberneom-edd2d.web.app',
  'https://cyberneom-edd2d.firebaseapp.com',
]);

// Strict model allowlist to prevent tampered clients from invoking expensive or
// arbitrary Vertex AI models on Itzli's billing account.
const ALLOWED_GEMINI_MODELS = new Set([
  'gemini-2.5-flash-lite',
  'gemini-2.5-flash',
  'gemini-2.5-pro',
  'gemini-2.0-flash-lite',
  'gemini-2.0-flash',
]);

// Sliding-window hourly rate limits per Firebase UID (or hashed guest IP).
const RATE_LIMIT_WINDOW_MS = 60 * 60 * 1000;
const GUEST_HOURLY_LIMIT = 20;
const GUEST_IP_HOURLY_LIMIT = 15;
const USER_HOURLY_LIMIT = 90;
const MAX_OUTPUT_TOKENS = 4096;
const GUEST_MAX_OUTPUT_TOKENS = 1024;
const MAX_CONTENTS_ITEMS = 120;
const MAX_SYSTEM_INSTRUCTION_CHARS = 28000;

const ITZLI_IDENTITY_LOCK =
  'Identidad soberana obligatoria: Eres Itzli, asistente inteligente del ecosistema Open Neom. ' +
  'NUNCA digas que eres Gemini, Google, Vertex AI, OpenAI, ChatGPT, Claude, Qwen ni ningún otro ' +
  'modelo o proveedor externo. Si te preguntan quién eres o qué modelo usas, responde únicamente que eres Itzli.';

class GeminiProxyError extends Error {
  constructor(code, message, httpStatus) {
    super(message);
    this.name = 'GeminiProxyError';
    this.code = code;
    this.httpStatus = httpStatus || _codeToHttpStatus(code);
  }
}

function _codeToHttpStatus(code) {
  switch (code) {
    case 'unauthenticated':
      return 401;
    case 'permission-denied':
      return 403;
    case 'invalid-argument':
      return 400;
    case 'resource-exhausted':
      return 429;
    case 'unavailable':
      return 503;
    default:
      return 500;
  }
}

function sanitizeText(raw, maxLen = 180) {
  const s = String(raw == null ? '' : raw)
    .replace(/Bearer\s+[A-Za-z0-9._~+/=-]+/gi, 'Bearer [REDACTED]')
    .replace(/AIza[0-9A-Za-z\-_]{20,}/g, '[REDACTED_KEY]')
    .replace(/[\r\n\t]+/g, ' ')
    .trim();
  return s.length > maxLen ? `${s.slice(0, maxLen)}…` : s;
}

function _isAnonymousAuth(auth) {
  const provider = auth && auth.token && auth.token.firebase && auth.token.firebase.sign_in_provider;
  return provider === 'anonymous';
}

function isTrustedGuestOrigin(req) {
  if (!req || !req.headers) return false;
  const origin = String(req.headers.origin || '').trim().toLowerCase();
  if (origin && ALLOWED_GUEST_ORIGINS.has(origin)) return true;
  const referer = String(req.headers.referer || '').trim().toLowerCase();
  if (referer) {
    for (const allowed of ALLOWED_GUEST_ORIGINS) {
      if (referer === allowed || referer.startsWith(`${allowed}/`)) return true;
    }
  }
  return false;
}

function _extractGuestIpHash(req) {
  const xff = req && req.headers && req.headers['x-forwarded-for'];
  const rawIp = typeof xff === 'string' && xff.trim()
    ? xff.split(',')[0].trim()
    : String((req && (req.ip || (req.socket && req.socket.remoteAddress))) || 'unknown');
  const digest = crypto.createHash('sha256').update(`cyberneom-itzli:${rawIp}`).digest('hex').slice(0, 24);
  return `guest_ip_${digest}`;
}

function resolveCallerIdentity({ auth, req }) {
  if (auth && auth.uid) {
    const isAnon = _isAnonymousAuth(auth);
    return {
      key: String(auth.uid).replace(/[^A-Za-z0-9_.-]/g, '_').slice(0, 128),
      limit: isAnon ? GUEST_HOURLY_LIMIT : USER_HOURLY_LIMIT,
      isGuest: isAnon,
    };
  }
  if (isTrustedGuestOrigin(req)) {
    return {
      key: _extractGuestIpHash(req),
      limit: GUEST_IP_HOURLY_LIMIT,
      isGuest: true,
    };
  }
  throw new GeminiProxyError('unauthenticated', 'Authentication required', 401);
}

function _resolveProjectId(explicitProjectId) {
  if (explicitProjectId && String(explicitProjectId).trim()) {
    return String(explicitProjectId).trim();
  }
  if (process.env.ITZLI_VERTEX_PROJECT_ID && process.env.ITZLI_VERTEX_PROJECT_ID.trim()) {
    return process.env.ITZLI_VERTEX_PROJECT_ID.trim();
  }
  return DEFAULT_VERTEX_PROJECT_ID;
}

let _sharedGoogleAuth = null;
async function _defaultGetAccessToken() {
  if (!_sharedGoogleAuth) {
    _sharedGoogleAuth = new GoogleAuth({
      scopes: ['https://www.googleapis.com/auth/cloud-platform'],
    });
  }
  const client = await _sharedGoogleAuth.getClient();
  const tokenResponse = await client.getAccessToken();
  const token = typeof tokenResponse === 'string'
    ? tokenResponse
    : (tokenResponse && tokenResponse.token);
  if (!token) {
    throw new GeminiProxyError('unavailable', 'Servicio de Itzli temporalmente no disponible.', 503);
  }
  return token;
}

function validateAndBuildVertexRequest(params, { isGuest = false } = {}) {
  const safeParams = params && typeof params === 'object' ? params : {};
  const targetModel = String(safeParams.model || DEFAULT_MODEL).trim();

  if (!ALLOWED_GEMINI_MODELS.has(targetModel)) {
    throw new GeminiProxyError(
      'invalid-argument',
      'Configuración de motor de Itzli no permitida.',
      400,
    );
  }

  const contents = safeParams.contents;
  if (!Array.isArray(contents) || contents.length === 0 || contents.length > MAX_CONTENTS_ITEMS) {
    throw new GeminiProxyError(
      'invalid-argument',
      `contents required (1..${MAX_CONTENTS_ITEMS} items)`,
      400,
    );
  }

  const body = { contents };

  if (typeof safeParams.systemInstruction === 'string' && safeParams.systemInstruction.trim()) {
    const trimmedSys = safeParams.systemInstruction.trim().slice(0, MAX_SYSTEM_INSTRUCTION_CHARS);
    const mergedSys = `${ITZLI_IDENTITY_LOCK}\n\n${trimmedSys}`;
    body.systemInstruction = {
      role: 'system',
      parts: [{ text: mergedSys }],
    };
  } else if (safeParams.systemInstruction && typeof safeParams.systemInstruction === 'object') {
    const existingParts = Array.isArray(safeParams.systemInstruction.parts)
      ? safeParams.systemInstruction.parts
      : [];
    body.systemInstruction = {
      ...safeParams.systemInstruction,
      parts: [{ text: ITZLI_IDENTITY_LOCK }, ...existingParts],
    };
  } else {
    body.systemInstruction = {
      role: 'system',
      parts: [{ text: ITZLI_IDENTITY_LOCK }],
    };
  }

  const rawCfg = safeParams.generationConfig && typeof safeParams.generationConfig === 'object'
    ? safeParams.generationConfig
    : {};
  const generationConfig = {};
  const tokenCap = isGuest ? GUEST_MAX_OUTPUT_TOKENS : MAX_OUTPUT_TOKENS;
  const maxOut = Number(rawCfg.maxOutputTokens);
  generationConfig.maxOutputTokens = Number.isFinite(maxOut) && maxOut >= 1
    ? Math.min(Math.floor(maxOut), tokenCap)
    : Math.min(2048, tokenCap);

  if (rawCfg.temperature !== undefined) {
    const temp = Number(rawCfg.temperature);
    if (Number.isFinite(temp)) {
      generationConfig.temperature = Math.min(Math.max(temp, 0), 2);
    }
  }
  if (rawCfg.topP !== undefined) {
    const topP = Number(rawCfg.topP);
    if (Number.isFinite(topP)) {
      generationConfig.topP = Math.min(Math.max(topP, 0), 1);
    }
  }
  if (rawCfg.topK !== undefined) {
    const topK = Number(rawCfg.topK);
    if (Number.isFinite(topK) && topK >= 1) {
      generationConfig.topK = Math.min(Math.floor(topK), 100);
    }
  }
  if (rawCfg.thinkingConfig && typeof rawCfg.thinkingConfig === 'object') {
    generationConfig.thinkingConfig = rawCfg.thinkingConfig;
  }
  body.generationConfig = generationConfig;

  if (Array.isArray(safeParams.tools) && safeParams.tools.length > 0) {
    body.tools = safeParams.tools;
  }
  if (safeParams.toolConfig && typeof safeParams.toolConfig === 'object') {
    body.toolConfig = safeParams.toolConfig;
  }

  return { targetModel, body };
}

async function enforceGeminiRateLimit({ db, auth, req = null, now = Date.now() }) {
  const caller = resolveCallerIdentity({ auth, req });
  if (!db) return caller;

  const docRef = db.collection('cyberneomGeminiRateLimits').doc(caller.key);

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    const data = snap.exists ? (snap.data() || {}) : {};
    const windowStart = typeof data.windowStart === 'number' ? data.windowStart : 0;
    const prevCount = typeof data.count === 'number' ? data.count : 0;

    const expired = (now - windowStart) >= RATE_LIMIT_WINDOW_MS;
    const nextStart = expired ? now : windowStart;
    const nextCount = expired ? 1 : prevCount + 1;

    if (nextCount > caller.limit) {
      throw new GeminiProxyError(
        'resource-exhausted',
        'Has alcanzado el límite horario de consultas en la nube. Intenta de nuevo más tarde.',
        429,
      );
    }

    tx.set(docRef, {
      windowStart: nextStart,
      count: nextCount,
      updatedAt: now,
    }, { merge: true });
  });

  return caller;
}

function buildVertexUrl({ projectId, location = DEFAULT_LOCATION, model, streaming = false }) {
  const safeProject = encodeURIComponent(projectId);
  const safeLocation = encodeURIComponent(location);
  const safeModel = encodeURIComponent(model);
  const method = streaming ? 'streamGenerateContent?alt=sse' : 'generateContent';
  return `https://${safeLocation}-aiplatform.googleapis.com/v1/projects/${safeProject}/locations/${safeLocation}/publishers/google/models/${safeModel}:${method}`;
}

async function handleGeminiProxy({
  params,
  auth,
  req = null,
  db = null,
  projectId = null,
  location = DEFAULT_LOCATION,
  fetchImpl = fetch,
  getAccessToken = _defaultGetAccessToken,
}) {
  const caller = await enforceGeminiRateLimit({ db, auth, req });
  const { targetModel, body } = validateAndBuildVertexRequest(params, { isGuest: caller.isGuest });
  const resolvedProject = _resolveProjectId(projectId);
  const accessToken = await getAccessToken();
  const url = buildVertexUrl({
    projectId: resolvedProject,
    location,
    model: targetModel,
    streaming: false,
  });

  const response = await fetchImpl(url, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
      'x-goog-user-project': resolvedProject,
    },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    const errText = await response.text().catch(() => '');
    console.error(`[itzliCloud] Upstream HTTP ${response.status}:`, sanitizeText(errText, 240));
    const code = response.status === 429
      ? 'resource-exhausted'
      : (response.status >= 400 && response.status < 500 ? 'invalid-argument' : 'unavailable');
    const clientMsg = response.status === 429
      ? 'Itzli está recibiendo demasiadas solicitudes ahora. Intenta en unos segundos.'
      : 'Itzli no pudo completar la respuesta en este momento. Intenta de nuevo.';
    throw new GeminiProxyError(
      code,
      clientMsg,
      response.status >= 400 && response.status < 600 ? response.status : 502,
    );
  }

  return await response.json();
}

async function handleGeminiStreamProxy({
  params,
  auth,
  req = null,
  res,
  db = null,
  projectId = null,
  location = DEFAULT_LOCATION,
  fetchImpl = fetch,
  getAccessToken = _defaultGetAccessToken,
}) {
  try {
    const caller = await enforceGeminiRateLimit({ db, auth, req });
    const { targetModel, body } = validateAndBuildVertexRequest(params, { isGuest: caller.isGuest });
    const resolvedProject = _resolveProjectId(projectId);
    const accessToken = await getAccessToken();
    const url = buildVertexUrl({
      projectId: resolvedProject,
      location,
      model: targetModel,
      streaming: true,
    });

    const upstream = await fetchImpl(url, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
        'x-goog-user-project': resolvedProject,
      },
      body: JSON.stringify(body),
    });

    if (!upstream.ok) {
      const errText = await upstream.text().catch(() => '');
      console.error(`[itzliCloudStream] Upstream HTTP ${upstream.status}:`, sanitizeText(errText, 240));
      const clientMsg = upstream.status === 429
        ? 'Itzli está recibiendo demasiadas solicitudes ahora. Intenta en unos segundos.'
        : 'Itzli no pudo completar la respuesta en este momento. Intenta de nuevo.';
      return res.status(upstream.status).json({
        error: {
          message: clientMsg,
          status: upstream.status === 429 ? 'resource-exhausted' : 'unavailable',
        },
      });
    }

    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    if (!upstream.body || typeof upstream.body.getReader !== 'function') {
      const text = await upstream.text();
      _emitSseLinesAsNdjson(text, res);
      return res.end();
    }

    const reader = upstream.body.getReader();
    const decoder = new TextDecoder('utf-8');
    let pending = '';

    for (;;) {
      const { done, value } = await reader.read();
      if (done) break;
      pending += decoder.decode(value, { stream: true });
      const lines = pending.split(/\r?\n/);
      pending = lines.pop() || '';
      for (const line of lines) {
        _emitSingleSseLine(line, res);
      }
    }
    if (pending.trim()) {
      _emitSingleSseLine(pending, res);
    }
    return res.end();
  } catch (err) {
    const status = (err instanceof GeminiProxyError) ? err.httpStatus : 500;
    const code = (err instanceof GeminiProxyError) ? err.code : 'internal';
    const message = sanitizeText(err && err.message ? err.message : 'Stream error', 220);
    if (!res.headersSent) {
      return res.status(status).json({ error: { message, status: code } });
    }
    res.write(`${JSON.stringify({ error: message })}\n`);
    return res.end();
  }
}

function _emitSseLinesAsNdjson(rawText, res) {
  for (const line of String(rawText || '').split(/\r?\n/)) {
    _emitSingleSseLine(line, res);
  }
}

function _emitSingleSseLine(line, res) {
  const trimmed = line.trim();
  if (!trimmed || !trimmed.startsWith('data:')) return;
  const payload = trimmed.slice(5).trim();
  if (!payload || payload === '[DONE]') return;
  try {
    const parsed = JSON.parse(payload);
    res.write(`${JSON.stringify(parsed)}\n`);
  } catch (_) {
    // Skip non-JSON SSE keepalive/comment frames
  }
}

module.exports = {
  ALLOWED_GEMINI_MODELS,
  ALLOWED_GUEST_ORIGINS,
  DEFAULT_MODEL,
  GUEST_HOURLY_LIMIT,
  GUEST_IP_HOURLY_LIMIT,
  USER_HOURLY_LIMIT,
  GeminiProxyError,
  buildVertexUrl,
  enforceGeminiRateLimit,
  handleGeminiProxy,
  handleGeminiStreamProxy,
  isTrustedGuestOrigin,
  resolveCallerIdentity,
  sanitizeText,
  validateAndBuildVertexRequest,
};
