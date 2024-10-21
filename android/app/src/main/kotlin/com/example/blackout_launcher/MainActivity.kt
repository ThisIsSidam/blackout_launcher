package com.example.blackout_launcher

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var appChangePlugin: AppChangePlugin? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        appChangePlugin = AppChangePlugin(applicationContext, flutterEngine)
    }

    override fun onDestroy() {
        appChangePlugin?.cleanup()
        appChangePlugin = null
        super.onDestroy()
    }
}