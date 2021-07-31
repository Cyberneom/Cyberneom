package com.cyberneom.neom

import android.os.Bundle
import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
