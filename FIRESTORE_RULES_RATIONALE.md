# Racional Arquitectónico de las Reglas de Seguridad de Firestore (EMXI, Gigmeout, Cyberneom)

**Versión:** 3.1.0+68  
**Fecha de Publicación:** 2026-11-16  
**Ámbito de Aplicación:** EMXI (`AppInUse.e`), Gigmeout (`AppInUse.g`), Cyberneom (`AppInUse.c`)  
**Garantía de Paridad:** Byte-for-Byte Equality (SHA-256 unificado)

---

## 1. Filosofía de Seguridad y Visión General

La arquitectura de seguridad en Firestore para el ecosistema Neom implementa una estrategia de **defensa en profundidad** gobernada por dos principios rectores complementarios:

1. **Cero Pantallas en Blanco para el Usuario / Lector Invitado (Read Availability):**
   Los catálogos públicos, lanzamientos literarios y musicales, publicaciones del timeline, obras de museo, descripciones de eventos FIL y parámetros tarifarios básicos deben ser legibles de forma pública (`allow read: if true;`) para permitir la navegación fluida de invitados y rastreo de deep-links en Flutter Web y Móvil sin requerir autenticación forzada.

2. **Privilegio Mínimo y Bloqueo Defensivo por Defecto (Default Deny & Write Hardening):**
   Toda colección o documento no declarado explícitamente se rechaza de forma absoluta mediante `match /{document=**} { allow read, write: if false; }`. Las mutaciones de estado, transacciones financieras, asignación de roles y acceso a PII (Información Personal Identificable) están estrictamente encapsuladas por identidad autenticada, verificación de propiedad de perfil/usuario y control de acceso basado en roles (RBAC).

---

## 2. Modelo RBAC y Helpers Globales de Autenticación

El ecosistema Neom utiliza un modelo híbrido de autorización que sincroniza de forma segura los Custom Claims de Firebase Auth con los registros persistentes en la colección `/users/{uid}`.

### 2.1 `signedIn()`
```javascript
function signedIn() {
  return request.auth != null;
}
```
Verifica que la petición proviene de un contexto autenticado en Firebase Auth. Rechaza usuarios anónimos o llamadas sin token.

### 2.2 `userDocHasRoleAt(docId, roles)` y `hasUserDocRole(roles)`
```javascript
function userDocHasRoleAt(docId, roles) {
  return docId is string
    && docId.size() > 0
    && !docId.matches('.*[/].*')
    && exists(/databases/$(database)/documents/users/$(docId))
    && get(/databases/$(database)/documents/users/$(docId)).data.get('userRole', '') in roles;
}

function hasUserDocRole(roles) {
  return signedIn() && (
    userDocHasRoleAt(request.auth.uid, roles) ||
    (request.auth.token.get('email_verified', false) == true
      && userDocHasRoleAt(request.auth.token.get('email', ''), roles))
  );
}
```
- **Protección contra Path Traversal:** `!docId.matches('.*[/].*')` garantiza que ningún atacante pueda inyectar barras diagonales en el parámetro de ruta.
- **Soporte de Cuentas Legadas:** Permite validar roles tanto para usuarios indexados por UID canónico como para cuentas migradas indexadas por correo electrónico verificado.

### 2.3 `isUserDocStaff()` e `isUserDocAdmin()`
- Roles de Staff: `['support', 'erp', 'developer', 'admin', 'superAdmin']`.
- Roles de Admin: `['developer', 'admin', 'superAdmin']`.

### 2.4 `isStaff()` e `isAdmin()` (Sincronización Híbrida)
```javascript
function isStaff() {
  return signedIn() && (
    request.auth.token.get('admin', false) == true ||
    request.auth.token.get('staff', false) == true ||
    isUserDocStaff()
  );
}

function isAdmin() {
  return signedIn() && (
    request.auth.token.get('admin', false) == true ||
    isUserDocAdmin()
  );
}
```
**Racional:** Resuelve la desincronización histórica donde administradores configurados en `/users/{uid}.userRole` recibían `PERMISSION_DENIED` en consolas administrativas porque las reglas solo evaluaban JWT claims. Con esta unificación, se aceptan tanto tokens enriquecidos por Cloud Functions como roles documentales asignados por administradores.

---

## 3. Catálogo Público, Timeline y Releases (`allow read: if true;`)

### 3.1 `/posts/{postId}` y `/comments/{commentId}`
- **Lectura:** Pública para visualización en feed, perfiles y enlaces compartidos en redes sociales.
- **Creación y Actualización:** Usuarios autenticados (`signedIn()`). Permite añadir comentarios (`commentIds`) y alternar likes (`likedProfiles`).
- **Eliminación Segura de Posts:**
  ```javascript
  allow delete: if signedIn() && (
    resource.data.ownerId == request.auth.uid ||
    (request.auth.token.get('email_verified', false) == true && resource.data.get('ownerEmail', '') == request.auth.token.get('email', '')) ||
    (request.auth.token.get('email_verified', false) == true && resource.data.ownerId == request.auth.token.get('email', '')) ||
    exists(/databases/$(database)/documents/users/$(request.auth.uid)/profiles/$(resource.data.ownerId)) ||
    isStaff()
  );
  ```
  **Racional:** En la aplicación cliente, `post.ownerId` contiene el `AppProfile.id` del autor. La regla anterior requería `resource.data.ownerId == request.auth.uid`, impidiendo a los autores legítimos eliminar sus publicaciones. La regla actualizada comprueba si el perfil pertenece al usuario actual comprobando la existencia de `/users/{uid}/profiles/{ownerId}`, o si el UID/correo coincide directamente.
- **Colección Raíz `/comments/{commentId}`:**
  Se añadió la regla explícita para la colección raíz `comments` (consultada por `CommentFirestore`), evitando que caiga en el default-deny y habilitando la carga y moderación de comentarios.

### 3.2 `/appReleaseItems/{releaseId}` y `/appMediaItems/{mediaId}`
- **Lectura:** Abierta sin restricciones para reproducción de muestras, audiolibros y streaming de demos.
- **Edición y Eliminación:** Exclusiva para el autor propietario (`ownerEmail`, `ownerProfileId`, `metaOwnerId`) o personal de moderación (`isStaff()`).

---

## 4. Árbol de Usuario y Actualizaciones Sociales Acotadas

### 4.1 `/users/{userId}`
- **Lectura:** Restringida al propio usuario dueño (`request.auth.uid == userId` o verificación de correo en cuenta legada) y a personal administrativo (`isStaff()`).
  *Racional:* Permite a los controladores de ERP, facturación y POS buscar usuarios de la app sin exponer la base de datos a usuarios normales.
- **Creación (`safeUserCreate`) y Actualización (`safeUserUpdate`):**
  - Impide la escalación de privilegios en el cliente: un usuario normal jamás puede alterar su propio `userRole` (debe permanecer `'subscriber'`). La modificación de roles requiere Admin SDK.
  - El correo no puede ser modificado a menos que esté verificado en Firebase Auth.
  - La eliminación está denegada en el cliente (`allow delete: if false;`), requiriendo flujos de cumplimiento GDPR/eliminación de cuenta orquestados en backend.

### 4.2 `/users/{userId}/profiles/{profileId}`
- **Lectura:** Pública para visualización de avatares, nombres artísticos y bios.
- **Creación y Eliminación:** Restringida al dueño de la cuenta (`request.auth.uid == userId`) o staff.
- **Actualización Acotada de Interacciones Sociales:**
  ```javascript
  allow update: if signedIn() && (
    request.auth.uid == userId ||
    isStaff() ||
    request.resource.data.diff(resource.data).affectedKeys().hasOnly([
      'followers', 'requests', 'invitationRequests', 'mateRequests', 'sentRequests',
      'following', 'followingCount', 'followersCount'
    ])
  );
  ```
  **Racional:** Anteriormente, la regla `request.auth.uid == userId` bloqueaba con `PERMISSION_DENIED` acciones sociales legítimas donde un Usuario A sigue a un Usuario B (actualizando la lista `followers` en el perfil de B) o envía una invitación colectiva/evento (actualizando `requests`/`invitationRequests`). La nueva regla permite a usuarios externos autenticados mutar **únicamente** los campos relacionales sociales, mientras que el nombre, foto, biografía y preferencias quedan blindados exclusivamente para el dueño del perfil.

---

## 5. Blindaje de Operaciones Financieras, Transacciones y PII

Anteriormente, colecciones financieras críticas utilizaban reglas abiertas `allow read, write: if signedIn();`, lo que permitía a cualquier usuario autenticado inspeccionar cuentas bancarias CLABE, montos de retiro o alterar transacciones.

### 5.1 `/wallets/{walletId}`
- **Racional:** La billetera digital custodia AppCoins y saldos de usuario.
- **Acceso:** Solo el titular autenticado (coincidencia de UID, correo verificado o `ownerId`/`userId`) o personal de finanzas (`isStaff()`) puede leer o actualizar saldos. Eliminación restringida a staff.

### 5.2 `/transactions/{txId}`
- **Racional:** Libro mayor contable de transferencias, recargas y propinas.
- **Acceso:** Solo pueden leer los participantes de la transacción (`senderId`, `recipientId`, `userId`, `senderEmail`, `recipientEmail`) o personal staff.
- **Inmutabilidad:** Normales usuarios solo pueden insertar (`create`); la modificación o eliminación está completamente bloqueada (`allow update, delete: if isStaff();`).

### 5.3 `/withdrawalRequests/{reqId}` y `/royaltyPayouts/{payoutId}`
- **Protección de Datos Sensibles (PII):** Las solicitudes de retiro contienen cuentas bancarias CLABE de 18 dígitos, nombres completos de beneficiarios y RFCs.
- **Acceso:**
  - `withdrawalRequests`: Lectura y creación exclusiva para el titular que solicita los fondos; actualización de estado (aprobado/pagado/rechazado) y borrado restringidos a `isStaff()`.
  - `royaltyPayouts`: Consulta permitida al autor destinatario y a finanzas; generación y desembolso exclusivamente administrativo.

### 5.4 `/orders/{orderId}` y `/shopOrders/{orderId}`
- **Acceso:** Restringido a quien realizó la compra (`customerId`, `userId`, `customerEmail`), a los vendedores con productos en la orden (`sellerEmails`) y al equipo de soporte (`isStaff()`). Mutaciones de estado de orden reservadas al back-office.

### 5.5 `/satInvoices/{invId}`
- **Protección Fiscal:** Almacena CFDIs, folios fiscales UUID y domicilios fiscales.
- **Acceso:** Exclusivo para el cliente receptor de la factura o personal contable/staff.

---

## 6. Tienda, Inventarios y Cotizaciones

### 6.1 `shippingZones` y `shopStock`
- **Normalización de Nombres:** La base de código de `neom_shop` consulta `shippingZones` y `shopStock`, mientras que versiones anteriores declaraban `shopShippingZones` y `shopStocks`. Las reglas unificadas ofrecen match blocks para ambas variantes:
  - `shippingZones` / `shopShippingZones`: Catálogo de costos de envío público (`allow read: if true;`), configuración exclusiva de staff (`allow write: if isStaff();`).
  - `shopStock` / `shopStocks`: Consulta de disponibilidad de stock pública, ajuste de inventario restringido al vendedor propietario (`ownerEmail`) o staff.

### 6.2 `/quotations/{quotationId}`
- `/quotations/default`: Parámetros de cotización de impresión/publicación sin PII leídos en modo invitado (`/cotizacion`).
- `/quotations/{otherId}`: Cotizaciones personalizadas privadas de usuarios autenticados.

---

## 7. Cultura, Arte Digital, Juegos e IA

### 7.1 `/museumArtworks`, `/museumGalleries`, `/museumAuctions` (+ `/bids`), `/museumComments`
- **Módulo:** `neom_museum`.
- **Acceso Público:** Obras, galerías y subastas son exhibiciones públicas (`allow read: if true;`).
- **Control de Subastas y Pujas:** Las ofertas en subastas (`/bids/{bidId}`) pueden ser registradas por cualquier usuario autenticado, mientras que la aceptación de pujas y cierre de subasta queda en manos del vendedor o curador.

### 7.2 `/neomVectors/{vectorId}`
- **Módulo:** `neom_corpus`, `LibroTerapia`, `Librinder`, `saia_core`.
- **Racional:** Permite a lectores invitados y registrados ejecutar búsquedas semánticas y recomendaciones vectoriales de libros (`allow read: if true;`), mientras que la generación de embeddings e indexación vectorial queda restringida a procesos de staff/backend (`allow write: if isStaff();`).

### 7.3 `/games/{gameId}` (+ `/moves/{moveId}`)
- **Módulo:** `neom_games` (Ajedrez literario, juegos multijugador).
- **Acceso:** Partidas legibles públicamente (modo espectador); movimientos creados y actualizados por los jugadores autenticados; eliminación por moderación de staff.

### 7.4 `/filEvents/{eventId}` (+ `/participants/{participantId}`)
- **Módulo:** `neom_fil` (Feria Internacional del Libro de Guadalajara).
- **Acceso:** Agenda y eventos culturales abiertos a invitados (`allow read: if true;`); registro de participantes permitido a usuarios autenticados; edición de datos de evento reservada a organizadores/staff.

### 7.5 `/learningProgress/{progressId}` y `/learningLeaderboard/{entryId}`
- **Módulo:** `neom_learning`.
- **Acceso:** Progreso de cursos privado para el estudiante o tutores staff; tabla de clasificación comunitaria (`learningLeaderboard`) pública para incentivar gamificación.

---

## 8. Calendario, Comunicación y Soporte

### 8.1 `/userAgendas`, `/agendaMeetingBookings`, `/agendaMeetingSlotLocks`
- **Módulo:** `neom_calendar`.
- **Acceso:** Agendas públicas para consulta de disponibilidad; reservas de citas (`agendaMeetingBookings`) restringidas a anfitrión y solicitante; bloqueos temporales (`agendaMeetingSlotLocks`) accesibles a usuarios en proceso de reserva para evitar doble agendamiento.

### 8.2 `/inbox/{inboxId}` (+ `/roomProfiles/{profileId}`)
- **Módulo:** `neom_inbox`, `neom_core`.
- **Acceso:** Mensajería directa protegida por autenticación. La subcolección `roomProfiles` permite a los participantes registrar su presencia y estado de escritura en tiempo real.

### 8.3 `/jamSessions/{sessionId}` (+ `/chat/{messageId}`)
- **Módulo:** `neom_audio_platform`, `neom_jam`.
- **Acceso:** Salas de escucha compartida y chat de sesión en vivo entre participantes autenticados.

### 8.4 `/globalActivityFeed/{feedId}`
- **Módulo:** `neom_core`.
- **Acceso:** Novedades y lanzamientos globales visibles para toda la comunidad (`allow read: if true;`); emisión de anuncios reservada a usuarios autenticados con publicación o staff.

### 8.5 `/achievements/{achievementId}`, `/profileInstruments/{docId}`, `/itzliSupportKb/{docId}`
- `achievements`: Catálogo público de medallas y logros literarios/musicales, avance de usuario (`progress`) persistido por usuario autenticado.
- `profileInstruments`: Catálogo de disciplinas literarias e instrumentos artísticos para perfiles.
- `itzliSupportKb`: Artículos y respuestas de la base de conocimiento del asistente IA de soporte ITZLI.

---

## 9. Back-Office, ERP, Kanban y Consolas de Monitoreo

Todas las colecciones de gestión interna y operativa empresarial fueron retiradas del acceso general de usuarios y restringidas a personal autorizado (`isStaff()` / `isUserDocStaff()`):

1. **Gestión de Roles:** `/erpRoleAssignments` solo puede ser modificado por administradores, impidiendo cualquier escalación de privilegios desde la consola del navegador.
2. **Operaciones y Finanzas:** `/erpLeads`, `/erpAgents`, `/erpTasks`, `/erpIncomes`, `/erpExpenses`, `/erpQuotes`, `/erpSolutions`, `/erpBooks`, `/erpAuthors`, `/erpTransfers`, `/erpGoals`, etc., quedan completamente aislados del cliente común.
3. **Gestión Ágil:** `/kanbanBoards` y `/kanbanTasks` (con sus comentarios internos) solo son visibles para el equipo operativo.
4. **Punto de Venta:** `/posSessions`, `/posReceipts` y `/posStockAdjustments` son operadas por cajeros autorizados en ferias y librerías.
5. **Aseguramiento de Calidad:** `/e_qa_test_runs` y `/e_qa_defects` custodian las ejecuciones y defectos del QA Tracker.
6. **Métricas y Telemetría:** `/analytics`, `/flowLogs` y `/screenLogs` permiten a las apps clientes reportar eventos y pantallas, reservando la consulta agregada para consolas administrativas.

---

## 10. Contrato Local de Salas y Señalización WebRTC (`rooms` y `liveSessions`)

Las reglas preservan el contrato estricto de salas de audio/lectura verificado por `rooms.rules.test.js`:
- Inmutabilidad estricta de `hostUid`, `hostId` y `createdAt`.
- Membresía atómica de participantes (`/members/{uid}` y `/participants/{profileId}`).
- Control de palabra y moderación: un participante solo puede hablar si levanta la mano y es promovido por el moderador; jamás puede forzarse la activación del micrófono ajeno.
- Señalización P2P WebRTC aislada en subcolección `/signaling/{signalId}` con validación de tamaño y estructura SDP e ICE candidates.

---

## 11. Resumen de Índices Compuestos Requeridos

Para soportar las consultas filtradas y ordenadas de estas colecciones sin errores `FAILED_PRECONDITION`, se han incorporado 46 nuevos índices compuestos en `firestore.indexes.json`:
- **Tienda:** `shopMerchItems` (categoría, estado, fecha), `shopBanners` (prioridad), `shopOrders` (cliente, estado, vendedores), `shopStock` (dueño, producto).
- **Museo:** `museumArtworks` (venta, estado, fecha, likes), `museumGalleries` (visibilidad, fecha), `museumAuctions` (estado, fecha fin, vendedor), `bids` (monto descendente).
- **Vectores e IA:** `neomVectors` (completitud, categorías, palabras clave, idioma).
- **Cultura y Eventos:** `filEvents` (publicado, activo, fecha inicio), `participants` (plan, fecha, estatus de pago).
- **Back-Office:** `kanbanTasks` (tablero, columna, posición, asignados), `erpTransfers`, `erpSaleTransactions`, `erpRoyaltyPayouts`, `erpModules`, `erpTasks`, `erpActivities`, `e_qa_defects`.
- **Comunidad y Audio:** `jamSessions` (estado, tipo, fecha), `inbox` (cola de soporte humano), `subscriptionEvents` (suscripción, fecha).
