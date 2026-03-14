const { onCall, onRequest } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const admin = require('firebase-admin');
admin.initializeApp();

const WOO_URL = defineSecret('WOO_URL');
const WP_USER = defineSecret('WP_USER');
const WP_APP_PASSWORD = defineSecret('WP_APP_PASSWORD');
const WOO_KEY = defineSecret('WOO_KEY');
const WOO_SECRET = defineSecret('WOO_SECRET');

exports.getWooProducts = onCall(
  {
    region: 'us-central1',
    secrets: [WOO_URL, WOO_KEY, WOO_SECRET],
  },
  async (request) => {
    const {
      page = 1,
      perPage = 25,
      status = 'publish',
      categoryIds = [],
    } = request.data;

    let url = `${WOO_URL.value()}/products?page=${page}&per_page=${perPage}&status=${status}`;

    console.log('Resolved WOO_URL:', WOO_URL.value());
    console.log('Final URL:', url);
    console.log('Using WP_USER:', WP_USER.value());
    console.log('Using WP_APP_PASSWORD:', WP_APP_PASSWORD.value());
    console.log('Category IDs:', categoryIds);
    console.log('Page:', page);
    console.log('Per Page:', perPage);
    console.log('Status:', status);

    if (categoryIds.length) {
      url += `&category=${categoryIds.join(',')}`;
    }

    const auth = Buffer.from(
      `${WOO_KEY.value()}:${WOO_SECRET.value()}`
    ).toString('base64');

    const res = await fetch(url, {
      headers: {
        Authorization: `Basic ${auth}`,
        Accept: 'application/json',
      },
    });

    const text = await res.text();

    console.log('Woo status:', res.status);
    console.log('Woo headers:', Object.fromEntries(res.headers.entries()));
    console.log('Woo raw body:', text);

    // 🔥 Protege contra HTML (captcha, WAF, error 403)
    if (!res.ok || text.trim().startsWith('<')) {
      throw new Error(`Woo response invalid (${res.status})`);
    }

    return JSON.parse(text);
  }
);

// ============================================================
// Cross-Promotion: getOrganicPromos — HTTP GET endpoint
// Returns public posts, events, and releases as OrganicPromoItem JSON.
// ============================================================
const CYBERNEOM_SOURCE_APP = 'c';
const CYBERNEOM_DEEP_LINK_SCHEME = 'cyberneom';

exports.getOrganicPromos = onRequest(
  { region: 'us-central1', cors: true },
  async (req, res) => {
    if (req.method !== 'GET') {
      return res.status(405).json({ error: 'Method not allowed' });
    }

    const db = admin.firestore();
    const promos = [];
    const limit = Math.min(parseInt(req.query.limit) || 20, 50);

    try {
      // 1. Recent posts — single field orderBy, filter in memory
      const postsSnap = await db.collection('posts')
        .orderBy('createdTime', 'desc')
        .limit(limit * 3)
        .get();

      let postCount = 0;
      postsSnap.docs.forEach(doc => {
        if (postCount >= limit) return;
        const d = doc.data();
        if (d.isPrivate === true || d.isDraft === true) return;
        promos.push({
          id: doc.id,
          sourceApp: CYBERNEOM_SOURCE_APP,
          itemType: d.type || 'post',
          title: d.profileName || '',
          description: d.caption || '',
          mediaUrl: d.mediaUrl || '',
          deepLink: `${CYBERNEOM_DEEP_LINK_SCHEME}://post/${doc.id}`,
        });
        postCount++;
      });

      // 2. Recent events — single field orderBy, filter public in memory
      const eventsSnap = await db.collection('events')
        .orderBy('createdTime', 'desc')
        .limit(limit * 2)
        .get();

      let eventCount = 0;
      eventsSnap.docs.forEach(doc => {
        if (eventCount >= limit) return;
        const d = doc.data();
        if (d.public !== true) return;
        promos.push({
          id: doc.id,
          sourceApp: CYBERNEOM_SOURCE_APP,
          itemType: d.type || 'event',
          title: d.name || '',
          description: d.description || '',
          mediaUrl: d.imgUrl || '',
          deepLink: `${CYBERNEOM_DEEP_LINK_SCHEME}://event/${doc.id}`,
        });
        eventCount++;
      });

      // 3. Recent release items
      const releasesSnap = await db.collection('appReleaseItems')
        .orderBy('createdTime', 'desc')
        .limit(limit)
        .get();

      releasesSnap.docs.forEach(doc => {
        const d = doc.data();
        promos.push({
          id: doc.id,
          sourceApp: CYBERNEOM_SOURCE_APP,
          itemType: d.type || 'appRelease',
          title: d.name || '',
          description: d.description || '',
          mediaUrl: d.imgUrl || '',
          deepLink: `${CYBERNEOM_DEEP_LINK_SCHEME}://release/${doc.id}`,
        });
      });

      res.status(200).json(promos);
    } catch (error) {
      console.error('Error fetching organic promos:', error);
      res.status(500).json({ error: 'Failed to fetch promos' });
    }
  }
);

// ============================================================
// secureOps — Secure configuration & operations proxy
// Secrets: firebase functions:secrets:set STRIPE_SECRET_KEY
//          firebase functions:secrets:set GOOGLE_API_KEY
// (WOO secrets already defined above for getWooProducts)
// ============================================================
const { HttpsError } = require('firebase-functions/v2/https');

const STRIPE_SECRET_KEY = defineSecret('STRIPE_SECRET_KEY');
const GOOGLE_API_KEY    = defineSecret('GOOGLE_API_KEY');

const CYBERNEOM_PUBLIC_CONFIG = {
  appName: 'Cyberneom',
  appBotName: 'Neom Bot',
  appSourceNames: { e: 'Emxi', g: 'Gigmeout', c: 'Cyberneom', i: 'Itzli', d: 'Srznik', o: 'Open Neom' },
  appStoreUrl: 'https://apps.apple.com/us/app/cyberneom/id6452385727',
  playStoreUrl: 'https://play.google.com/store/apps/details?id=com.cyberneom.neom',
  appLogoUrl: 'https://firebasestorage.googleapis.com/v0/b/cyberneom-edd2d.appspot.com/o/AppStatics%2FCyberneom%20Icono.png?alt=media&token=68bc867f-df6c-40fb-a8fe-e920242c21a1',
  jammingLogo: '',
  noImageUrl: 'https://firebasestorage.googleapis.com/v0/b/cyberneom-edd2d.appspot.com/o/AppStatics%2FNo%20Image%20Found.png?alt=media&token=e4461421-62fb-44df-a9e9-0c9ee7f19ccf',
  privacyPolicyUrl: 'https://cyberneom.xyz/politica-de-privacidad/',
  termsOfServiceUrl: 'https://cyberneom.xyz/terminos-de-servicio/',
  landingPageUrl: 'https://www.cyberneom.xyz/',
  webContact: 'https://www.cyberneom.xyz/contacto/',
  blogUrl: 'https://www.cyberneom.xyz/blog/',
  linksUrl: 'https://www.cyberneom.xyz/links/',
  eCommerceUrl: 'www.cyberneom.xyz',
  stripePublishableKey: 'pk_live_51NWMq2LmQzP15NffF3ElZCkvDbxFyuZeuhELQn6l7QOK4ciFzVUA0roKpkkgKDx6pivFV6jFvG2IGfjZNfY7Ngc000aamWN7qK',
  stripePublishableTestKey: 'pk_test_51NWMq2LmQzP15NffiQ7oBKiqH48YuTXshebnN5W07MTI8iFV4LIcaU1J24x0yh5pXTXR9pCkljVS36RzZKV8EGAq00vl2Kt954',
  buyMeACoffeeUrl: 'https://www.buymeacoffee.com/cyberneom',
  hubName: 'cyberneom.xyz',
  storageServerName: 'firebasestorage.googleapis.com',
  paymentGatewayBaseURL: 'https://api.stripe.com/v1',
  notificationChannelId: 'com.cyberneom.neom.channel.audio',
  notificationChannelName: 'Cyberneom',
  notificationIcon: 'drawable/ic_stat_music_note',
  siteUrl: 'https://www.cyberneom.xyz',
  subscriptionPlansUrl: 'https://www.cyberneom.xyz/planes-de-suscripcion',
  wooUrl: 'https://www.cyberneom.xyz/wp-json/wc/v3',
  wpUrl: 'https://www.cyberneom.xyz/wp-json/wp/v2',
  wooMainCategoryId: '28',
  wooSecondaryCategoryId: '',
  firebaseProjectId: 'cyberneom-edd2d',
  appCoinName: 'Neom Coin',
  subscriptionPrice: '59',
  subscriptionCURRENCY: 'MXN',
  whatsappBusinessNumber: '',
  whatsappURL: 'whatsapp://send?phone=+<phoneNumber>&text=<message>',
  devLinkedIn: 'https://www.linkedin.com/in/emmanuel-montoyae/',
  devGithub: 'https://github.com/emmanuel-montoya/',
  clipName: 'neomclip',
  mediaToWordpressFlag: 'false',
  ceoName: 'Emmanuel Montoya (CEO)',
  cooName: 'Eduardo Briseño (COO)',
  ccoName: 'Raul Navarro (CCO)',
  instagramUrl: 'https://www.instagram.com/cyberneomia/',
  contactEmail: 'cyberneom.om@gmail.com',
  wooPhysicalItemCategory: '0',
  wooDigitalItemCategory: '0',
  wooStreamingItemCategory: '0',
  wooSubscriptionItemCategory: '0',
  wooNupaleProductId: '640',
  wooCaseteProductId: '640',
  webClientId: '144129075582-gn8ap4f7n0n5bv0vdl5fnc8tqch2h5q1.apps.googleusercontent.com',
  serverClientId: '144129075582-gn8ap4f7n0n5bv0vdl5fnc8tqch2h5q1.apps.googleusercontent.com',
};

exports.secureOps = require('firebase-functions/v2/https').onCall(
  {
    region: 'us-central1',
    secrets: [STRIPE_SECRET_KEY, WOO_KEY, WOO_SECRET, WP_USER, WP_APP_PASSWORD, GOOGLE_API_KEY],
  },
  async (request) => {
    const { action, ...params } = request.data || {};

    if (action === 'getConfig') return CYBERNEOM_PUBLIC_CONFIG;

    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Authentication required');
    }

    switch (action) {
      case 'sendNotification': {
        const { token, title, body, data } = params;
        if (!token) throw new HttpsError('invalid-argument', 'token required');
        try {
          const msgId = await admin.messaging().send({
            notification: { title: title || '', body: body || '' },
            data: data || {},
            token,
          });
          return { success: true, messageId: msgId };
        } catch (err) {
          if (err.code === 'messaging/registration-token-not-registered') {
            return { success: false, error: 'token_expired' };
          }
          throw new HttpsError('internal', 'FCM send failed');
        }
      }

      case 'stripeProxy': {
        const { method, path, body } = params;
        if (!path) throw new HttpsError('invalid-argument', 'path required');
        const res = await fetch(`https://api.stripe.com/v1${path}`, {
          method: method || 'POST',
          headers: {
            'Authorization': `Bearer ${STRIPE_SECRET_KEY.value()}`,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body || undefined,
        });
        const json = await res.json();
        if (!res.ok) throw new HttpsError('internal', json.error?.message || 'Stripe error');
        return json;
      }

      case 'wooProxy': {
        const { method, path, body } = params;
        if (!path) throw new HttpsError('invalid-argument', 'path required');
        const auth = Buffer.from(`${WOO_KEY.value()}:${WOO_SECRET.value()}`).toString('base64');
        const res = await fetch(`${CYBERNEOM_PUBLIC_CONFIG.wooUrl}${path}`, {
          method: method || 'GET',
          headers: { 'Authorization': `Basic ${auth}`, 'Content-Type': 'application/json' },
          body: body ? JSON.stringify(body) : undefined,
        });
        const text = await res.text();
        if (!res.ok || text.trim().startsWith('<')) throw new HttpsError('internal', `Woo error (${res.status})`);
        return JSON.parse(text);
      }

      case 'wooMediaProxy': {
        const { method, path, body } = params;
        if (!path) throw new HttpsError('invalid-argument', 'path required');
        const auth = Buffer.from(`${WP_USER.value()}:${WP_APP_PASSWORD.value()}`).toString('base64');
        const res = await fetch(`${CYBERNEOM_PUBLIC_CONFIG.wpUrl}${path}`, {
          method: method || 'GET',
          headers: { 'Authorization': `Basic ${auth}`, 'Content-Type': 'application/json' },
          body: body ? JSON.stringify(body) : undefined,
        });
        const text = await res.text();
        if (!res.ok) throw new HttpsError('internal', `WP error (${res.status})`);
        return JSON.parse(text);
      }

      case 'getSecret':
        if (params.key === 'googleApiKey') return { value: GOOGLE_API_KEY.value() };
        throw new HttpsError('invalid-argument', `Unknown secret: ${params.key}`);

      default:
        throw new HttpsError('invalid-argument', `Unknown action: ${action}`);
    }
  }
);

// ============================================================
// stateOgMeta — Dynamic OG meta tags for /x/{stateId} sharing
// Called via /api/og/x/{stateId} rewrite in firebase.json
// ============================================================

const STATE_CATALOG = {
  'first-contact': { en: 'First Contact', es: 'Primer Contacto', desc: 'Alpha 10Hz binaural + screen strobe. See geometric patterns with closed eyes.', freq: '10Hz', dur: '5 min' },
  'sleep': { en: 'Deep Sleep', es: 'Sueno Profundo', desc: 'Delta 3Hz binaural descending from alpha to delta. For insomnia relief.', freq: '3Hz', dur: '20 min' },
  'focus': { en: 'Deep Focus', es: 'Enfoque Total', desc: '40Hz gamma enhancement for study and deep work.', freq: '40Hz', dur: '25 min' },
  'calm': { en: 'Calm Down', es: 'Calma', desc: 'Alpha descending to theta. Quick anxiety relief.', freq: '10-6Hz', dur: '10 min' },
  'meditate': { en: 'Deep Meditation', es: 'Meditacion Profunda', desc: '7Hz theta binaural. Pure sound, minimal screen.', freq: '7Hz', dur: '15 min' },
  'energy': { en: 'Wake Up', es: 'Energia', desc: 'Beta ascending to gamma. Morning or pre-workout boost.', freq: '20-35Hz', dur: '8 min' },
  'create': { en: 'Creative Flow', es: 'Flujo Creativo', desc: 'Theta-alpha border. Ideas flow state for artists.', freq: '7.5Hz', dur: '20 min' },
  'relief': { en: 'Pain Relief', es: 'Alivio del Dolor', desc: 'Stable alpha 10Hz reduces pain perception.', freq: '10Hz', dur: '15 min' },
  'presence': { en: 'The Presence', es: 'La Presencia', desc: '18.98Hz infrasound. Sensation of invisible presence.', freq: '18.98Hz', dur: '10 min' },
  'lucid': { en: 'Lucid Dreaming', es: 'Sueno Lucido', desc: 'Theta 5Hz with gamma bursts. Pre-sleep lucid dream induction.', freq: '5Hz', dur: '30 min' },
  'heart': { en: 'Heart Sync', es: 'Sincronizacion Cardiaca', desc: '7.83Hz Schumann resonance. Earth electromagnetic frequency.', freq: '7.83Hz', dur: '12 min' },
  '432': { en: 'Universal Harmony', es: 'Armonia Universal', desc: '432Hz pure tone. The universe frequency.', freq: '432Hz', dur: '15 min' },
  '528': { en: 'DNA Repair', es: 'Reparacion ADN', desc: '528Hz solfeggio frequency. Transformation and miracles.', freq: '528Hz', dur: '15 min' },
};

exports.stateOgMeta = onRequest(
  { region: 'us-central1', cors: true },
  async (req, res) => {
    // Extract stateId from path: /api/og/x/{stateId}
    const pathParts = req.path.split('/').filter(Boolean);
    const stateId = pathParts[pathParts.length - 1] || '';
    const state = STATE_CATALOG[stateId];

    if (!state) {
      return res.status(404).json({ error: 'State not found' });
    }

    // Detect language from query param or Accept-Language header
    const lang = req.query.lang || (req.headers['accept-language'] || '').slice(0, 2);
    const name = (lang === 'es' && state.es) ? state.es : state.en;
    const title = `${name} — Cyberneom`;
    const description = `${state.desc} ${state.freq} | ${state.dur}`;
    const url = `https://cyberneom.xyz/x/${stateId}`;

    res.set('Content-Type', 'text/html; charset=utf-8');
    res.set('Cache-Control', 'public, max-age=3600');

    return res.send(`<!DOCTYPE html>
<html lang="${lang || 'en'}">
<head>
  <meta charset="utf-8">
  <title>${title}</title>
  <meta name="description" content="${description}">
  <meta property="og:title" content="${title}">
  <meta property="og:description" content="${description}">
  <meta property="og:url" content="${url}">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="Cyberneom">
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="${title}">
  <meta name="twitter:description" content="${description}">
  <meta http-equiv="refresh" content="0;url=${url}">
</head>
<body>
  <p>Redirecting to <a href="${url}">${title}</a>...</p>
  <script>window.location.replace("${url}");</script>
</body>
</html>`);
  }
);
