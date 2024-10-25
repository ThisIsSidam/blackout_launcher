package com.example.blackout_launcher

import android.app.Activity
import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // For AppChange Plugin
    private var appChangePlugin: AppChangePlugin? = null

    private val CHANNEL = "com.example.app/widgets"
    private lateinit var appWidgetManager: AppWidgetManager
    private lateinit var appWidgetHost: AppWidgetHost
    private val WIDGET_HOST_ID = 1024
    private val REQUEST_BIND_WIDGET = 1
    private lateinit var providers: List<AppWidgetProviderInfo>
    private var isWidgetHostStarted = false

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)

        // Initialize these in onCreate instead of configureFlutterEngine
        appWidgetManager = AppWidgetManager.getInstance(context)
        appWidgetHost = AppWidgetHost(context, WIDGET_HOST_ID)
        providers = appWidgetManager.installedProviders
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        appChangePlugin = AppChangePlugin(applicationContext, flutterEngine)

        // Add this line to register the platform view factory
//        flutterEngine.platformViewsController.registry.registerViewFactory(
//            "android-widget-view",
//            AndroidWidgetViewFactory(appWidgetHost, appWidgetManager)
//        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAvailableWidgets" -> {
                    val widgets = getAvailableWidgets()
                    result.success(widgets)
                }

                "addWidget" -> {
                    val widgetId = call.argument<Int>("widgetId")!!
                    addWidget(widgetId, result)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        try {
            if (isWidgetHostStarted) {
                appWidgetHost.stopListening()
                isWidgetHostStarted = false
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error cleaning up widget host: ${e.message}")
        }
        appChangePlugin?.cleanup()
        appChangePlugin = null
        super.onDestroy()
    }


    private fun getAvailableWidgets(): List<Map<String, Any>> {
        return providers.map { provider ->
            mapOf(
                "id" to provider.provider.shortClassName,
                "label" to provider.loadLabel(context.packageManager),
                "previewImage" to provider.previewImage,
                "minWidth" to provider.minWidth,
                "minHeight" to provider.minHeight
            )
        }
    }

    private fun addWidget(providerId: Int, result: MethodChannel.Result) {
        try {
            val appWidgetId = appWidgetHost.allocateAppWidgetId()
            val provider = providers[providerId]

            // Start listening before binding if not already started
            if (!isWidgetHostStarted) {
                appWidgetHost.startListening()
                isWidgetHostStarted = true
            }

            val success = appWidgetManager.bindAppWidgetIdIfAllowed(
                appWidgetId,
                provider.provider
            )

            if (success) {
                result.success(appWidgetId)
            } else {
                // Request permission if needed
                val intent = Intent(AppWidgetManager.ACTION_APPWIDGET_BIND).apply {
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_PROVIDER, provider.provider)
                }
                startActivityForResult(intent, REQUEST_BIND_WIDGET)
            }
        } catch (e: Exception) {
            result.error("WIDGET_ERROR", e.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_BIND_WIDGET) {
            // Handle widget binding result
            if (resultCode == Activity.RESULT_OK) {
                val widgetId = data?.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1)
                if (widgetId != -1) {
                    // Widget was successfully bound
                    // You might want to send this back to Flutter
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        try {
            if (!isWidgetHostStarted) {
                appWidgetHost.startListening()
                isWidgetHostStarted = true
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error starting widget host: ${e.message}")
        }
    }

    override fun onPause() {
        super.onPause()
        try {
            if (isWidgetHostStarted) {
                appWidgetHost.stopListening()
                isWidgetHostStarted = false
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error stopping widget host: ${e.message}")
        }
    }
}