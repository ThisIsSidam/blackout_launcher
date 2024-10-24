package com.example.blackout_launcher

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.Intent
import android.os.Bundle
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

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        appChangePlugin = AppChangePlugin(applicationContext, flutterEngine)

        appWidgetManager = AppWidgetManager.getInstance(context)
        appWidgetHost = AppWidgetHost(context, WIDGET_HOST_ID)
        providers = appWidgetManager.installedProviders

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
        }
    }
}