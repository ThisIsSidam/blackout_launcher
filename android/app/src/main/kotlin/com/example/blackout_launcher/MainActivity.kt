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
    private var lastAllocatedWidgetId: Int = -1

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)

        appWidgetManager = AppWidgetManager.getInstance(this)
        appWidgetHost = AppWidgetHost(this, WIDGET_HOST_ID)
        providers = appWidgetManager.installedProviders
        Log.d("WidgetDebug", "onCreate: Found ${providers.size} widget providers")
    }

    private fun startWidgetHost() {
        if (!isWidgetHostStarted) {
            try {
                appWidgetHost.startListening()
                isWidgetHostStarted = true
            } catch (e: Exception) {
                Log.e("MainActivity", "Error starting widget host: ${e.message}")
            }
        }
    }

    private fun stopWidgetHost() {
        if (isWidgetHostStarted) {
            try {
                appWidgetHost.stopListening()
                isWidgetHostStarted = false
            } catch (e: Exception) {
                Log.e("MainActivity", "Error stopping widget host: ${e.message}")
            }
        }
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

    private fun getAvailableWidgets(): List<Map<String, Any>> {
        Log.d("WidgetDebug", "Available providers: ${providers.size}")
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
        Log.d("WidgetDebug", "Starting addWidget with providerId: $providerId")
        try {
            if (providerId >= providers.size) {
                Log.e("WidgetDebug", "Invalid providerId: $providerId, max: ${providers.size - 1}")
                result.error("INVALID_PROVIDER", "Invalid provider ID", null)
                return
            }

            // Allocate widget ID
            lastAllocatedWidgetId = appWidgetHost.allocateAppWidgetId()
            Log.d("WidgetDebug", "Allocated widget ID: $lastAllocatedWidgetId")

            val provider = providers[providerId]
            Log.d("WidgetDebug", "Selected provider: ${provider.provider.shortClassName}")

            // Ensure widget host is listening
            if (!isWidgetHostStarted) {
                Log.d("WidgetDebug", "Starting widget host")
                appWidgetHost.startListening()
                isWidgetHostStarted = true
            }

            // Store the result callback
            pendingResults[lastAllocatedWidgetId] = result

            // Create the bind intent
            val bindIntent = Intent(AppWidgetManager.ACTION_APPWIDGET_BIND).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, lastAllocatedWidgetId)
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_PROVIDER, provider.provider)
            }

            // Start the activity properly
            startActivityForResult(bindIntent, REQUEST_BIND_WIDGET)
            Log.d(
                "WidgetDebug",
                "Started permission activity for widget ID: $lastAllocatedWidgetId"
            )

        } catch (e: Exception) {
            Log.e("WidgetDebug", "Error in addWidget", e)
            result.error("WIDGET_ERROR", e.message, null)
        }
    }

    // Store pending results for widget binding
    private val pendingResults = mutableMapOf<Int, MethodChannel.Result>()

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d("WidgetDebug", "onActivityResult: requestCode=$requestCode, resultCode=$resultCode")

        if (requestCode == REQUEST_BIND_WIDGET) {
            // Use the last allocated widget ID if data is null
            val widgetId =
                data?.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, lastAllocatedWidgetId)
                    ?: lastAllocatedWidgetId

            Log.d("WidgetDebug", "Processing result for widget ID: $widgetId")

            val result = pendingResults.remove(widgetId)
            if (result == null) {
                Log.e("WidgetDebug", "No pending result found for widget ID: $widgetId")
                return
            }

            when (resultCode) {
                Activity.RESULT_OK -> {
                    Log.d("WidgetDebug", "Widget binding successful")
                    // Verify the widget is actually bound
                    val widgetInfo = appWidgetManager.getAppWidgetInfo(widgetId)
                    if (widgetInfo != null) {
                        result.success(widgetId)
                    } else {
                        Log.e("WidgetDebug", "Widget appears bound but no info available")
                        appWidgetHost.deleteAppWidgetId(widgetId)
                        result.error("BIND_FAILED", "Widget binding verification failed", null)
                    }
                }

                Activity.RESULT_CANCELED -> {
                    Log.d("WidgetDebug", "Widget binding cancelled by user")
                    appWidgetHost.deleteAppWidgetId(widgetId)
                    result.error("BIND_CANCELLED", "Widget binding cancelled by user", null)
                }

                else -> {
                    Log.d("WidgetDebug", "Widget binding failed with result code: $resultCode")
                    appWidgetHost.deleteAppWidgetId(widgetId)
                    result.error("BIND_FAILED", "Failed to bind widget", null)
                }
            }
        }
    }

    override fun onDestroy() {
        if (isWidgetHostStarted) {
            appWidgetHost.stopListening()
            isWidgetHostStarted = false
        }
        super.onDestroy()
    }
}