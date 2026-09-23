# ================= JACKSON =================
-keep class com.fasterxml.jackson.databind.** { *; }
-dontwarn com.fasterxml.jackson.databind.**

# ================= SPOTIFY SDK =================
-keep class com.spotify.protocol.mappers.jackson.ImageUriJson$Deserializer { *; }
-keep class com.spotify.protocol.mappers.jackson.ImageUriJson$Serializer { *; }
-dontwarn com.spotify.protocol.**

# ================= STRIPE SDK =================
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.**

# Mantener actividades, servicios y broadcast receivers
-keep class * extends android.app.Activity
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider

# ================= SCENEFORM / ARCORE =================
-dontwarn com.google.ar.sceneform.**
-dontwarn com.google.devtools.build.android.desugar.runtime.**
-keep class com.google.ar.sceneform.** { *; }
-keep class com.google.ar.core.** { *; }
-dontwarn com.google.ar.core.**
