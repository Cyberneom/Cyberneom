#!/usr/bin/env python3
"""Generate Cyberneom_Web_Regression_Testing_Checklist.xlsx.

Cyberneom is the wellness/biohacking app of the Open Neom ecosystem.
v3.0.0+27 includes 50+ neom_modules with strong emphasis on:

  - Cognitive fitness (PAR) — readiness assessment, tactical protocols
  - Biofeedback — mic-based breath/movement detection
  - Historic state — frequency descent training (10→7.5Hz)
  - Frequencies & sound therapy
  - VR experiences
  - Standard social/commerce/audio (shared with EMXI/Gigmeout)

Test cases focus on Cyberneom-distinctive features alongside the
common ecosystem flows (auth, posts, audio, stripe, itzli embed).
"""
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.datavalidation import DataValidation
from openpyxl.formatting.rule import CellIsRule
from pathlib import Path

OUTPUT = Path(__file__).parent / "Cyberneom_Web_Regression_Testing_Checklist.xlsx"

ARIAL = "Arial"
ACCENT = "00897B"        # Cyberneom teal
HEADER_FILL = "D5EFE9"
ZEBRA = "F4FAF8"

thin = Side(style="thin", color="B7CEC9")
border_all = Border(left=thin, right=thin, top=thin, bottom=thin)

wb = Workbook()


def style_header(ws, row, cols):
    for c in range(1, cols + 1):
        cell = ws.cell(row=row, column=c)
        cell.font = Font(name=ARIAL, bold=True, color="FFFFFF", size=11)
        cell.fill = PatternFill("solid", start_color=ACCENT)
        cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        cell.border = border_all


def set_col_widths(ws, widths):
    for i, w in enumerate(widths, start=1):
        ws.column_dimensions[get_column_letter(i)].width = w


# ============================================================
# Test cases — (Code, Module, Area, Priority, Title, Pre, Steps, Expected, PlatformNote)
# ============================================================
CASES = [
    # ── Smoke / Boot ──────────────────────────────────────
    ("SMK-01","neom_commons","Smoke","P0","Cold boot web","Browser limpio","Abrir landing","Carga < 5s",""),
    ("SMK-02","neom_commons","Smoke","P0","Cold boot android","APK","Lanzar","OK",""),
    ("SMK-03","neom_commons","Smoke","P0","Cold boot iOS","TestFlight","Lanzar","OK",""),
    ("SMK-04","neom_commons","Smoke","P0","Drawer principal","Login","Abrir drawer","Items navegan",""),
    ("SMK-05","neom_commons","Smoke","P1","Sin errores consola","Cualquier","F12","Sin rojos",""),
    ("SMK-06","neom_commons","Smoke","P1","Web manifest","Web","DevTools > Application","Manifest OK",""),
    ("SMK-07","neom_commons","Smoke","P0","Firebase init","Boot","Logs","Sin duplicate app",""),

    # ── Auth + Onboarding ─────────────────────────────────
    ("AUTH-01","neom_auth","Auth","P0","Login email","Cuenta test","Email + pwd","Home",""),
    ("AUTH-02","neom_auth","Auth","P0","Login Google","Cuenta Google","Sign-in","OK",""),
    ("AUTH-03","neom_auth","Auth","P0","Login Apple","Cuenta Apple","Sign-in","OK","⚠ Web-limited"),
    ("AUTH-04","neom_auth","Auth","P0","Logout","Sesión","Drawer > Logout","Landing",""),
    ("AUTH-05","neom_auth","Auth","P1","Recuperar password","Email","Forgot","Email reset",""),
    ("AUTH-06","neom_auth","Auth","P1","Persistencia sesión","Login","Cerrar/abrir","Sigue",""),

    ("ONB-01","neom_onboarding","Onboarding","P0","Flujo primer uso","Cuenta nueva","Completar","Llega Home",""),
    ("ONB-02","neom_onboarding","Onboarding","P1","Selección rol","Onboarding","Pick rol","Guardado",""),
    ("ONB-03","neom_onboarding","Onboarding","P2","Skip pasos","Onboarding","Skip","Continúa",""),

    # ── PAR (Profesional de Alto Rendimiento) — distinctive
    ("PAR-01","neom_par","PAR","P0","Home PAR","Login","/par","Dashboard cognitive fitness",""),
    ("PAR-02","neom_par","PAR","P0","Readiness assessment","PAR home","/par/readiness","Mic CV 60s arranca",""),
    ("PAR-03","neom_par","PAR","P0","Mic CV calibración","Readiness","Hablar 60s","CV calculado",""),
    ("PAR-04","neom_par","PAR","P0","Score readiness","CV calculado","Ver","Score 0-100 + percentil",""),
    ("PAR-05","neom_par","PAR","P1","Protocolo táctico 1","PAR home","/par/protocol/1","Carga + steps",""),
    ("PAR-06","neom_par","PAR","P1","Protocolo táctico 2","PAR home","/par/protocol/2","Carga + steps",""),
    ("PAR-07","neom_par","PAR","P1","Protocolo táctico 3","PAR home","/par/protocol/3","Carga + steps",""),
    ("PAR-08","neom_par","PAR","P1","Consistency heatmap","Sesiones previas","Ver","GitHub-style grid",""),
    ("PAR-09","neom_par","PAR","P1","Percentile engine","Multiple sessions","Ver","Curva percentiles",""),
    ("PAR-10","neom_par","PAR","P2","Report PNG export","Sesión","Share","Imagen generada",""),
    ("PAR-11","neom_par","PAR","P2","DeskSensor background","Desktop","Habilitar","Monitoreo silencioso","🚫 Web-excluded"),
    ("PAR-12","neom_par","PAR","P2","Persistencia sesiones","2 sesiones","Reiniciar","Ambas siguen",""),

    # ── Biofeedback ─────────────────────────────────
    ("BIO-01","neom_biofeedback","Biofeedback","P0","Permiso mic","Primera vez","Trigger","Pide permiso",""),
    ("BIO-02","neom_biofeedback","Biofeedback","P0","Breath detector","Mic OK","Respirar 30s","Detecta ciclos",""),
    ("BIO-03","neom_biofeedback","Biofeedback","P0","Movement detector","Mic OK","Hablar/moverse","Eventos",""),
    ("BIO-04","neom_biofeedback","Biofeedback","P1","HSS calculator","Datos","Computar","S_r × e^(-γ × I_m)",""),
    ("BIO-05","neom_biofeedback","Biofeedback","P1","Provider interface","Mic provider","Inject","Funciona como API",""),
    ("BIO-06","neom_biofeedback","Biofeedback","P2","Calibración ruido","Ambiente nuevo","Calibrar","Baseline OK",""),
    ("BIO-07","neom_biofeedback","Biofeedback","P2","Butterworth filter","Audio raw","Procesar","100-1200Hz pasa",""),

    # ── Historic State (frequency descent) ────────────────
    ("HST-01","neom_historic_state","HistoricState","P0","Iniciar sesión","Login","/historicState","UI carga",""),
    ("HST-02","neom_historic_state","HistoricState","P0","Fase 1 Anchor","Sesión","Iniciar","10Hz mantiene",""),
    ("HST-03","neom_historic_state","HistoricState","P0","Fase 2 Diffusion","Anchor OK","Continuar","Desciende a ~8.5Hz",""),
    ("HST-04","neom_historic_state","HistoricState","P0","Fase 3 ExistentialBase","Diffusion OK","Continuar","Llega 7.5Hz",""),
    ("HST-05","neom_historic_state","HistoricState","P1","Micro-breaks","Durante sesión","Wait","Pausas auto",""),
    ("HST-06","neom_historic_state","HistoricState","P1","Resultados fl_chart","Fin sesión","Ver","Gráficas",""),
    ("HST-07","neom_historic_state","HistoricState","P1","Persistencia historicSessions","Fin","Reiniciar","En Firestore",""),
    ("HST-08","neom_historic_state","HistoricState","P2","Translations 4 idiomas","Settings","Switch","ES/EN/FR/DE",""),

    # ── Frequencies / Sound therapy ───────────────────────
    ("FRQ-01","neom_frequencies","Frequencies","P1","Catálogo frecuencias","Login","/frequencies","Lista",""),
    ("FRQ-02","neom_frequencies","Frequencies","P1","Reproducir 528Hz","Frequency","Play","Tono",""),
    ("FRQ-03","neom_frequencies","Frequencies","P1","Reproducir 432Hz","Frequency","Play","Tono",""),
    ("FRQ-04","neom_frequencies","Frequencies","P2","Combinar dos frecuencias","Multi","Mix","Beat",""),
    ("FRQ-05","neom_frequencies","Frequencies","P2","Timer auto-stop","Frequency","Set timer","Detiene",""),

    # ── States ────────────────────────────────────────────
    ("STA-01","neom_states","States","P1","Lista de states","Login","/states","Estados emocionales",""),
    ("STA-02","neom_states","States","P1","Seleccionar state","States","Pick","Score guardado",""),
    ("STA-03","neom_states","States","P2","Histórico states","Multiple","Ver","Línea temporal",""),

    # ── VR ────────────────────────────────────────────────
    ("VR-01","neom_vr","VR","P2","Catálogo VR","Login","Drawer > VR","Lista experiencias","⚠ Web-limited"),
    ("VR-02","neom_vr","VR","P2","Iniciar experiencia","VR","Start","Carga 360°","⚠ Web-limited"),
    ("VR-03","neom_vr","VR","P3","Compatibilidad headset","Quest","Conectar","Detecta","🚫 Web-excluded"),

    # ── Experiences ───────────────────────────────────────
    ("EXP-01","neom_experiences","Experiences","P1","Catálogo experiencias","Login","/experiences","Lista",""),
    ("EXP-02","neom_experiences","Experiences","P1","Detalle experiencia","Catálogo","Click","Info",""),
    ("EXP-03","neom_experiences","Experiences","P2","Reservar","Detalle","Book","Pago",""),

    # ── Generator + Inter + Downloads ─────────────────────
    ("GEN-01","neom_generator","Generator","P2","Generar contenido","Login","Use generator","Output",""),
    ("INT-01","neom_inter","Inter","P2","Sesión interactiva","Login","Start","Interactive content",""),
    ("DLD-01","neom_downloads","Downloads","P2","Descargar contenido offline","Login","Download","Disponible offline","⚠ Web-limited"),

    # ── Profile + Mates ───────────────────────────────────
    ("PRF-01","neom_profile","Profile","P0","Ver perfil","Login","Drawer > Profile","Datos",""),
    ("PRF-02","neom_profile","Profile","P0","Editar perfil","Login","Edit > Save","Guarda",""),
    ("PRF-03","neom_profile","Profile","P1","Cambiar foto","Login","Upload","Avatar",""),
    ("PRF-04","neom_profile","Profile","P1","Perfil otro","Login","Abrir","Datos públicos",""),

    ("MAT-01","neom_mates","Mates","P1","Lista mates","Login","Mates","Lista",""),
    ("MAT-02","neom_mates","Mates","P2","Pedir mate","Otro perfil","Send","Pendiente",""),

    # ── Posts + Home ──────────────────────────────────────
    ("HOM-01","neom_home","Home","P0","Feed carga","Login","Home","Posts visibles",""),
    ("HOM-02","neom_home","Home","P1","Scroll infinito","Login","Scroll","+ contenido",""),
    ("HOM-03","neom_home","Home","P1","Pull refresh","Login","F5","Actualiza",""),

    ("PST-01","neom_posts","Posts","P0","Crear post texto","Login","Compose","Aparece",""),
    ("PST-02","neom_posts","Posts","P0","Crear post imagen","Login","Upload","Visible",""),
    ("PST-03","neom_posts","Posts","P1","Like","Login","Heart","+1",""),
    ("PST-04","neom_posts","Posts","P1","Comentar","Login","Comment","Visible",""),
    ("PST-05","neom_posts","Posts","P2","Eliminar","Owner","Delete","Removido",""),

    # ── Audio + Releases ──────────────────────────────────
    ("AUD-01","neom_audio_player","Audio","P0","Player visible","Login","Play","Bottom",""),
    ("AUD-02","neom_audio_player","Audio","P0","Play/pause","Track","Toggle","Funciona",""),
    ("AUD-03","neom_audio_player","Audio","P1","Next/prev","Queue","Next","Cambia",""),
    ("AUD-04","neom_audio_player","Audio","P1","Smart queue","Track end","Wait","Recom",""),
    ("AUD-05","neom_audio_player","Audio","P2","Sleep timer","Player","Set","Detiene",""),

    ("REL-01","neom_releases","Releases","P0","Detalle release","Login","Abrir","Datos",""),
    ("REL-02","neom_releases","Releases","P0","Reproducir track","Release","Play","Audio",""),
    ("REL-03","neom_releases","Releases","P1","Like","Login","Heart","Favs",""),

    # ── Inbox + Notif + Search ────────────────────────────
    ("MSG-01","neom_inbox","Inbox","P0","Lista chats","Login","Inbox","Carga",""),
    ("MSG-02","neom_inbox","Inbox","P0","Enviar texto","Chat","Send","Entregado",""),
    ("MSG-03","neom_inbox","Inbox","P1","Recibir tiempo real","2 cuentas","Send","Llega",""),

    ("NOT-01","neom_notifications","Notif","P0","Lista notif","Login","Drawer","Carga",""),
    ("NOT-02","neom_notifications","Notif","P1","Marcar leídas","Login","Mark all","0",""),

    ("SCH-01","neom_search","Search","P0","Buscar usuario","Login","Search","Resultados",""),
    ("SCH-02","neom_search","Search","P1","Buscar release","Login","Search","Resultados",""),

    # ── Events + Calendar + Booking ───────────────────────
    ("EVT-01","neom_events","Events","P1","Ver eventos","Login","Drawer","Lista",""),
    ("EVT-02","neom_events","Events","P1","Detalle evento","Login","Abrir","Datos",""),
    ("EVT-03","neom_events","Events","P2","RSVP","Login","Attend","Estado",""),

    ("CAL-01","neom_calendar","Calendar","P1","Ver calendario","Login","Drawer","Vista mes",""),
    ("BKG-01","neom_booking","Booking","P1","Reservar slot","Servicio","Book","Confirma",""),

    # ── Stripe + Subscriptions ────────────────────────────
    ("SUB-01","neom_stripe","Stripe","P0","Listar planes","Login","Plans","Cards",""),
    ("SUB-02","neom_stripe","Stripe","P0","Checkout","Login","Subscribe","Stripe",""),
    ("SUB-03","neom_stripe","Stripe","P0","Callback OK","Pago","Return","Activa",""),
    ("SUB-04","neom_stripe","Stripe","P0","Callback fail","Card fail","Return","Error",""),
    ("SUB-05","neom_stripe","Stripe","P1","Cancelar","Activa","Cancel","Cancelada",""),
    ("SUB-06","neom_stripe","Stripe","P1","Badge tier","Activa","Profile","Visible",""),

    # ── Wallet ────────────────────────────────────────────
    ("WAL-01","neom_bank","Wallet","P1","Saldo","Login","Wallet","Correcto",""),
    ("WAL-02","neom_bank","Wallet","P2","Comprar coins","Wallet","Buy","Sube",""),

    # ── ERP + Admin ───────────────────────────────────────
    ("ERP-01","neom_erp","ERP","P2","Acceso ERP","Admin","ERP","Dashboard",""),
    ("ADM-01","neom_admin","Admin","P1","Acceso admin","Admin","Drawer","Dashboard",""),
    ("ADM-02","neom_admin","Admin","P2","QA Tracker","Admin","Open QA","Carga (via neom_qa_tracker)",""),

    # ── Learning + Books ──────────────────────────────────
    ("LRN-01","neom_learning","Learning","P1","Tree nodos","Login","/learning","Visible",""),
    ("LRN-02","neom_learning","Learning","P1","Completar quiz","Tree","Quiz","XP+",""),
    ("LRN-03","neom_learning","Learning","P2","Hearts","5","Fail 5","Bloquea",""),

    ("BOK-01","neom_books","Books","P2","Catálogo","Login","/books","Lista",""),
    ("BOK-02","neom_books","Books","P2","Leer capítulo","Book","Open","Texto",""),

    # ── Itzli embed ───────────────────────────────────────
    ("EMB-01","neom_ia","Embed","P1","Bubble visible","Login","Landing","FAB",""),
    ("EMB-02","neom_ia","Embed","P1","Abrir chat","Bubble","Click","Panel",""),
    ("EMB-03","neom_ia","Embed","P1","Enviar prompt","Chat","Send","Respuesta",""),
    ("EMB-04","neom_ia","Embed","P1","Deeplink chips","Respuesta","Tap","Sint.toNamed",""),

    # ── Camera + uploads ──────────────────────────────────
    ("CAM-01","neom_camera","Camera","P1","Foto","Mobile","Camera","Imagen","🚫 Web-excluded"),
    ("CAM-02","neom_image_editor","ImgEdit","P2","Crop","Imagen","Crop","Editada",""),
    ("CAM-03","neom_media_upload","Upload","P1","Upload progresivo","Archivo","Upload","Progress",""),

    # ── TTS + Cloud ───────────────────────────────────────
    ("TTS-01","neom_tts","TTS","P2","Default flutter_tts","Login","Speak","Audio",""),
    ("TTS-02","neom_tts","TTS","P2","Switch provider","API key","Settings","Cambio",""),

    ("CLD-01","neom_cloud","Cloud","P2","Auth Drive","Google","Authorize","Token",""),

    # ── Settings ──────────────────────────────────────────
    ("SET-01","neom_settings","Settings","P1","Idioma","Login","Settings > lang","Traducida",""),
    ("SET-02","neom_settings","Settings","P1","Theme","Login","Toggle","Cambia",""),
    ("SET-03","neom_settings","Settings","P2","Notif toggles","Login","Settings","Persistido",""),

    # ── Routing / Deep links ──────────────────────────────
    ("RTE-01","neom_commons","Routing","P0","Deep link perfil","Sin login","URL","Visible",""),
    ("RTE-02","neom_commons","Routing","P0","Deep link release","Sin login","URL","Visible",""),
    ("RTE-03","neom_commons","Routing","P0","Deep link /par","Sin login","URL","Carga PAR",""),
    ("RTE-04","neom_commons","Routing","P0","Deep link /historicState","Sin login","URL","Carga HSS",""),
    ("RTE-05","neom_commons","Routing","P1","404","N/A","URL inválida","404",""),
    ("RTE-06","neom_commons","Routing","P1","Back browser","Login","Back","Funciona",""),

    # ── Performance ───────────────────────────────────────
    ("PRF-01","neom_commons","Performance","P1","Carga Home < 3s","Login","Cronometrar","< 3s",""),
    ("PRF-02","neom_commons","Performance","P1","Lighthouse ≥80","Web","Audit","Pass",""),
    ("PRF-03","neom_commons","Performance","P1","Memory leak scroll","Home","5 min","Estable",""),
    ("PRF-04","neom_commons","Performance","P2","PAR mic CV overhead","60s grabación","Cronometrar","No bloquea UI",""),

    # ── Cross-platform ────────────────────────────────────
    ("XPL-01","neom_commons","Cross","P0","Web Chrome","Chrome 120","Boot","OK",""),
    ("XPL-02","neom_commons","Cross","P1","Web Firefox","Firefox 120","Boot","OK",""),
    ("XPL-03","neom_commons","Cross","P1","Web Safari","Safari 17","Boot","OK",""),
    ("XPL-04","neom_commons","Cross","P0","Android","Pixel","APK","OK",""),
    ("XPL-05","neom_commons","Cross","P0","iOS","iPhone","TestFlight","OK",""),
    ("XPL-06","neom_commons","Cross","P2","Mic permissions iOS","iOS","PAR","Pide y graba",""),
    ("XPL-07","neom_commons","Cross","P2","Mic permissions Android","Android","PAR","Pide y graba",""),
    ("XPL-08","neom_commons","Cross","P2","Mic permissions Web","Web","PAR","Pide y graba",""),

    # ── Errors ────────────────────────────────────────────
    ("ERR-01","neom_commons","Errors","P1","Network drop","Sin red","Acción","Error claro",""),
    ("ERR-02","neom_commons","Errors","P1","Session expiry","Login","Wait","Redirige",""),
    ("ERR-03","neom_commons","Errors","P1","Mic denied","PAR","Denegar permiso","Mensaje claro",""),
    ("ERR-04","neom_commons","Errors","P2","Servidor 500","Trigger","Acción","No técnico",""),

    # ── Security ──────────────────────────────────────────
    ("SEC-01","neom_auth","Security","P0","XSS","Login","<script>","Escapado",""),
    ("SEC-02","neom_auth","Security","P0","Session expiry","Login","Wait","Redirige",""),
    ("SEC-03","neom_auth","Security","P1","Permisos rol","User","/admin","Bloqueado",""),
    ("SEC-04","neom_par","Security","P0","Mic data no se sube","PAR","Capturar","Solo CV local",""),
    ("SEC-05","neom_biofeedback","Security","P0","Audio raw no persiste","Bio","Sesión","Solo features",""),

    # ── i18n ──────────────────────────────────────────────
    ("I18N-01","neom_commons","i18n","P1","ES default","Boot","UI","ES",""),
    ("I18N-02","neom_commons","i18n","P1","EN switch","Settings","Toggle","EN",""),
    ("I18N-03","neom_commons","i18n","P2","FR switch","Settings","Toggle","FR",""),
    ("I18N-04","neom_commons","i18n","P2","DE switch","Settings","Toggle","DE",""),
    ("I18N-05","neom_commons","i18n","P3","PAR 4 traducciones","Settings","Switch","Sin keys raw",""),
    ("I18N-06","neom_commons","i18n","P3","HistoricState 40 keys","Settings","Switch","Sin keys raw",""),

    # ── Accessibility ─────────────────────────────────────
    ("A11Y-01","neom_commons","A11y","P2","Tab nav","Cualquier","Tab","Focus visible",""),
    ("A11Y-02","neom_commons","A11y","P2","Contraste AA","Cualquier","Audit","Cumple",""),
    ("A11Y-03","neom_commons","A11y","P3","Screen reader","Cualquier","NVDA/VO","Leíble",""),
]

# ============================================================
# Sheet 1: Summary
# ============================================================
ws_sum = wb.active
ws_sum.title = "Summary"

ws_sum["A1"] = "Cyberneom Web — Regression Testing Checklist"
ws_sum["A1"].font = Font(name=ARIAL, size=16, bold=True, color=ACCENT)
ws_sum.merge_cells("A1:E1")

ws_sum["A2"] = "Version:"
ws_sum["B2"] = "3.0.0+27"
ws_sum["A3"] = "URL:"
ws_sum["B3"] = "https://cyberneom-edd2d.web.app"
ws_sum["A4"] = "Tester(s):"
ws_sum["B4"] = ""
ws_sum["A5"] = "Fecha inicio:"
ws_sum["B5"] = ""
ws_sum["A6"] = "Fecha fin:"
ws_sum["B6"] = ""
for r in range(2, 7):
    ws_sum.cell(row=r, column=1).font = Font(name=ARIAL, bold=True)
    ws_sum.cell(row=r, column=2).fill = PatternFill("solid", start_color="FFFF00")

ws_sum["A8"] = "KPI"
ws_sum["B8"] = "Valor"
style_header(ws_sum, 8, 2)

total = len(CASES)
kpis = [
    ("Total de casos", f'=COUNTA(\'Test Cases\'!A2:A{total+1})'),
    ("Passed", f'=COUNTIF(\'Test Cases\'!F2:F{total+1},"Passed")'),
    ("Failed", f'=COUNTIF(\'Test Cases\'!F2:F{total+1},"Failed")'),
    ("Blocked", f'=COUNTIF(\'Test Cases\'!F2:F{total+1},"Blocked")'),
    ("Skipped", f'=COUNTIF(\'Test Cases\'!F2:F{total+1},"Skipped")'),
    ("Not Run", f'=COUNTIF(\'Test Cases\'!F2:F{total+1},"Not Run")'),
    ("% Cobertura", f'=IFERROR((B10+B11+B12+B13)/B9,0)'),
    ("% Pass rate", f'=IFERROR(B10/(B10+B11),0)'),
]
for i, (label, formula) in enumerate(kpis):
    r = 9 + i
    ws_sum.cell(row=r, column=1, value=label).font = Font(name=ARIAL, bold=True)
    ws_sum.cell(row=r, column=1).border = border_all
    c = ws_sum.cell(row=r, column=2, value=formula)
    c.border = border_all
    c.alignment = Alignment(horizontal="right")
    if "%" in label:
        c.number_format = "0.0%"

ws_sum["A18"] = "Prioridad"
ws_sum["B18"] = "Total"
ws_sum["C18"] = "Passed"
ws_sum["D18"] = "Failed"
ws_sum["E18"] = "Pendientes"
style_header(ws_sum, 18, 5)
for i, p in enumerate(["P0", "P1", "P2", "P3"]):
    r = 19 + i
    ws_sum.cell(row=r, column=1, value=p).font = Font(name=ARIAL, bold=True)
    ws_sum.cell(row=r, column=2, value=f'=COUNTIF(\'Test Cases\'!D2:D{total+1},"{p}")')
    ws_sum.cell(row=r, column=3, value=f'=COUNTIFS(\'Test Cases\'!D2:D{total+1},"{p}",\'Test Cases\'!F2:F{total+1},"Passed")')
    ws_sum.cell(row=r, column=4, value=f'=COUNTIFS(\'Test Cases\'!D2:D{total+1},"{p}",\'Test Cases\'!F2:F{total+1},"Failed")')
    ws_sum.cell(row=r, column=5, value=f'=COUNTIFS(\'Test Cases\'!D2:D{total+1},"{p}",\'Test Cases\'!F2:F{total+1},"Not Run")')
    for c in range(1, 6):
        ws_sum.cell(row=r, column=c).border = border_all

set_col_widths(ws_sum, [22, 60, 14, 14, 16])

# ============================================================
# Sheet 2: Test Cases
# ============================================================
ws_tc = wb.create_sheet("Test Cases")
headers = ["Code","Module","Area","Priority","Title","Status","X (done)","Tester","Date","Comment","Defect ID","Preconditions","Steps","Expected","Platform Note"]
ws_tc.append(headers)
style_header(ws_tc, 1, len(headers))
ws_tc.row_dimensions[1].height = 30

for row_idx, case in enumerate(CASES, start=2):
    code, mod, area, pri, title, pre, steps, exp, note = case
    ws_tc.cell(row=row_idx, column=1, value=code)
    ws_tc.cell(row=row_idx, column=2, value=mod)
    ws_tc.cell(row=row_idx, column=3, value=area)
    ws_tc.cell(row=row_idx, column=4, value=pri)
    ws_tc.cell(row=row_idx, column=5, value=title)
    ws_tc.cell(row=row_idx, column=6, value="Not Run")
    ws_tc.cell(row=row_idx, column=12, value=pre)
    ws_tc.cell(row=row_idx, column=13, value=steps)
    ws_tc.cell(row=row_idx, column=14, value=exp)
    ws_tc.cell(row=row_idx, column=15, value=note)

    for c in range(1, len(headers) + 1):
        cell = ws_tc.cell(row=row_idx, column=c)
        cell.border = border_all
        cell.alignment = Alignment(vertical="top", wrap_text=True)
        cell.font = Font(name=ARIAL, size=10)
        if row_idx % 2 == 0:
            cell.fill = PatternFill("solid", start_color=ZEBRA)

ws_tc.freeze_panes = "A2"
ws_tc.auto_filter.ref = f"A1:{get_column_letter(len(headers))}{len(CASES)+1}"
set_col_widths(ws_tc, [12,22,18,10,38,12,10,14,12,30,12,30,40,30,16])

dv_status = DataValidation(type="list", formula1='"Not Run,Passed,Failed,Blocked,Skipped"', allow_blank=True)
dv_status.add(f"F2:F{len(CASES)+1}")
ws_tc.add_data_validation(dv_status)

green = PatternFill("solid", start_color="C6EFCE")
red = PatternFill("solid", start_color="FFC7CE")
yellow = PatternFill("solid", start_color="FFEB9C")
gray = PatternFill("solid", start_color="E7E6E6")
blue = PatternFill("solid", start_color="D5E8F0")

rng = f"F2:F{len(CASES)+1}"
ws_tc.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Passed"'], fill=green))
ws_tc.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Failed"'], fill=red))
ws_tc.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Blocked"'], fill=yellow))
ws_tc.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Skipped"'], fill=gray))
ws_tc.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Not Run"'], fill=blue))

# ============================================================
# Sheet 3: By Module
# ============================================================
ws_mod = wb.create_sheet("By Module")
modules = sorted(set(c[1] for c in CASES))
ws_mod.append(["Module","Total","Passed","Failed","Blocked","Skipped","Not Run","% Pass"])
style_header(ws_mod, 1, 8)
last_row = len(CASES) + 1
for i, m in enumerate(modules):
    r = i + 2
    ws_mod.cell(row=r, column=1, value=m)
    ws_mod.cell(row=r, column=2, value=f'=COUNTIF(\'Test Cases\'!B2:B{last_row},A{r})')
    ws_mod.cell(row=r, column=3, value=f'=COUNTIFS(\'Test Cases\'!B2:B{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Passed")')
    ws_mod.cell(row=r, column=4, value=f'=COUNTIFS(\'Test Cases\'!B2:B{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Failed")')
    ws_mod.cell(row=r, column=5, value=f'=COUNTIFS(\'Test Cases\'!B2:B{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Blocked")')
    ws_mod.cell(row=r, column=6, value=f'=COUNTIFS(\'Test Cases\'!B2:B{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Skipped")')
    ws_mod.cell(row=r, column=7, value=f'=COUNTIFS(\'Test Cases\'!B2:B{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Not Run")')
    ws_mod.cell(row=r, column=8, value=f'=IFERROR(C{r}/(C{r}+D{r}),0)')
    ws_mod.cell(row=r, column=8).number_format = "0.0%"
    for c in range(1, 9):
        ws_mod.cell(row=r, column=c).border = border_all
        ws_mod.cell(row=r, column=c).font = Font(name=ARIAL, size=10)
set_col_widths(ws_mod, [26, 10, 10, 10, 10, 10, 10, 12])

# ============================================================
# Sheet 4: By Area
# ============================================================
ws_area = wb.create_sheet("By Area")
areas = sorted(set(c[2] for c in CASES))
ws_area.append(["Area","Total","Passed","Failed","Pendientes","% Pass"])
style_header(ws_area, 1, 6)
for i, a in enumerate(areas):
    r = i + 2
    ws_area.cell(row=r, column=1, value=a)
    ws_area.cell(row=r, column=2, value=f'=COUNTIF(\'Test Cases\'!C2:C{last_row},A{r})')
    ws_area.cell(row=r, column=3, value=f'=COUNTIFS(\'Test Cases\'!C2:C{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Passed")')
    ws_area.cell(row=r, column=4, value=f'=COUNTIFS(\'Test Cases\'!C2:C{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Failed")')
    ws_area.cell(row=r, column=5, value=f'=COUNTIFS(\'Test Cases\'!C2:C{last_row},A{r},\'Test Cases\'!F2:F{last_row},"Not Run")')
    ws_area.cell(row=r, column=6, value=f'=IFERROR(C{r}/(C{r}+D{r}),0)')
    ws_area.cell(row=r, column=6).number_format = "0.0%"
    for c in range(1, 7):
        ws_area.cell(row=r, column=c).border = border_all
        ws_area.cell(row=r, column=c).font = Font(name=ARIAL, size=10)
set_col_widths(ws_area, [22, 10, 10, 10, 12, 12])

# ============================================================
# Sheet 5: Defects Log
# ============================================================
ws_def = wb.create_sheet("Defects Log")
ws_def.append(["Defect ID","Case Code","Severity","Title","Steps","Actual","Expected","Platform","Screenshot URL","Assigned","Status","Created","Closed"])
style_header(ws_def, 1, 13)
for r in range(2, 60):
    for c in range(1, 14):
        ws_def.cell(row=r, column=c).border = border_all
        ws_def.cell(row=r, column=c).font = Font(name=ARIAL, size=10)
dv_sev = DataValidation(type="list", formula1='"P0,P1,P2,P3"', allow_blank=True)
dv_sev.add("C2:C200")
ws_def.add_data_validation(dv_sev)
dv_dst = DataValidation(type="list", formula1='"Open,In Progress,Fixed,Verified,Closed,Wont Fix"', allow_blank=True)
dv_dst.add("K2:K200")
ws_def.add_data_validation(dv_dst)
set_col_widths(ws_def, [12,12,10,32,36,28,28,20,24,16,14,12,12])

# ============================================================
# Sheet 6: Release Gates
# ============================================================
ws_rg = wb.create_sheet("Release Gates")
ws_rg["A1"] = "Criterios de aceptación (Release Gates)"
ws_rg["A1"].font = Font(name=ARIAL, size=14, bold=True, color=ACCENT)
ws_rg.merge_cells("A1:C1")
ws_rg.append([])
ws_rg.append(["Criterio","Target","Estado"])
style_header(ws_rg, 3, 3)
last = len(CASES) + 1
gates = [
    ("P0 con 100% Pass rate","100%", f'=IF(COUNTIFS(\'Test Cases\'!D2:D{last},"P0",\'Test Cases\'!F2:F{last},"Failed")=0,"OK","BLOCKED")'),
    ("P1 con >=95% Pass rate",">=95%", f'=IF(IFERROR(COUNTIFS(\'Test Cases\'!D2:D{last},"P1",\'Test Cases\'!F2:F{last},"Passed")/COUNTIF(\'Test Cases\'!D2:D{last},"P1"),0)>=0.95,"OK","REVIEW")'),
    ("P2 con >=80% ejecutados",">=80%", f'=IF(IFERROR((COUNTIFS(\'Test Cases\'!D2:D{last},"P2",\'Test Cases\'!F2:F{last},"Passed")+COUNTIFS(\'Test Cases\'!D2:D{last},"P2",\'Test Cases\'!F2:F{last},"Failed"))/COUNTIF(\'Test Cases\'!D2:D{last},"P2"),0)>=0.8,"OK","REVIEW")'),
    ("Sin defectos P0 abiertos","0", f'=IF(COUNTIFS(\'Defects Log\'!C2:C200,"P0",\'Defects Log\'!K2:K200,"Open")=0,"OK","BLOCKED")'),
    ("Cobertura global >=90%",">=90%", f'=IF(Summary!B15>=0.9,"OK","REVIEW")'),
    ("PAR readiness funciona","yes", '=IF(COUNTIFS(\'Test Cases\'!A2:A300,"PAR-04",\'Test Cases\'!F2:F300,"Passed")>0,"OK","BLOCKED")'),
    ("HSS frequency descent OK","yes", '=IF(COUNTIFS(\'Test Cases\'!A2:A300,"HST-04",\'Test Cases\'!F2:F300,"Passed")>0,"OK","BLOCKED")'),
    ("Mic data privacy","yes", '=IF(COUNTIFS(\'Test Cases\'!A2:A300,"SEC-04",\'Test Cases\'!F2:F300,"Passed")>0,"OK","BLOCKED")'),
]
for i, (crit, tgt, formula) in enumerate(gates):
    r = 4 + i
    ws_rg.cell(row=r, column=1, value=crit)
    ws_rg.cell(row=r, column=2, value=tgt)
    ws_rg.cell(row=r, column=3, value=formula)
    for c in range(1, 4):
        ws_rg.cell(row=r, column=c).border = border_all
        ws_rg.cell(row=r, column=c).font = Font(name=ARIAL, size=10)

ws_rg.conditional_formatting.add("C4:C12", CellIsRule(operator="equal", formula=['"OK"'], fill=green))
ws_rg.conditional_formatting.add("C4:C12", CellIsRule(operator="equal", formula=['"BLOCKED"'], fill=red))
ws_rg.conditional_formatting.add("C4:C12", CellIsRule(operator="equal", formula=['"REVIEW"'], fill=yellow))
set_col_widths(ws_rg, [48, 14, 14])

wb.save(OUTPUT)
print(f"OK written: {OUTPUT}")
print(f"Total cases: {len(CASES)}")

# ============================================================
# Also emit cases.json for the agnostic neom_qa_tracker submodule.
# Cyberneom is AppInUse.c — its qaTrackerConfig.c entry in
# properties.json points to the asset path that copies this file.
# ============================================================
import json

cases_json = [
    {
        "code": c[0],
        "module": c[1],
        "area": c[2],
        "priority": c[3],
        "title": c[4],
        "preconditions": c[5],
        "steps": c[6],
        "expectedResult": c[7],
        "platformNote": c[8],
    }
    for c in CASES
]
cases_json_path = OUTPUT.parent / "cases.json"
cases_json_path.write_text(
    json.dumps(cases_json, ensure_ascii=False, indent=2),
    encoding="utf-8",
)
print(f"OK written: {cases_json_path}")
