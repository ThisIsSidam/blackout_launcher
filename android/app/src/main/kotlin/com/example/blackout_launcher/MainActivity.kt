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
    private var appChangePlugin: AppChangePlugin? = null
    private val CHANNEL = "com.example.app/widgets"
    private val WIDGET_HOST_ID = 1024
    private val REQUEST_BIND_WIDGET = 1

    // Initialize these early to avoid null issues
    private val appWidgetManager: AppWidgetManager by lazy {
        AppWidgetManager.getInstance(this)
    }

    private val appWidgetHost: AppWidgetHost by lazy {
        AppWidgetHost(this, WIDGET_HOST_ID)
    }

    private val providers: List<AppWidgetProviderInfo> by lazy {
        appWidgetManager.installedProviders
    }

    private var isWidgetHostStarted = false
    private var lastAllocatedWidgetId: Int = -1
    private val pendingResults = mutableMapOf<Int, MethodChannel.Result>()

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)

        // Start listening for widgets immediately
        startWidgetHost()

        Log.d("WidgetDebug", "onCreate: Found ${providers.size} widget providers")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize AppChangePlugin
        appChangePlugin = AppChangePlugin(applicationContext, flutterEngine)

        // Register the platform view factory
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "android-widget-view",
            AndroidWidgetViewFactory(appWidgetHost, appWidgetManager)
        )

        // Set up method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAvailableWidgets" -> {
                        try {
                            val widgets = getAvailableWidgets()
                            result.success(widgets)
                        } catch (e: Exception) {
                            result.error("GET_WIDGETS_ERROR", e.message, null)
                        }
                    }

                    "addWidget" -> {
                        try {
                            val providerId =
                                call.argument<String>("providerId") // Changed from widgetId to providerId
                            if (providerId != null) {
                                addWidget(providerId, result)
                            } else {
                                result.error("INVALID_ARGS", "Provider ID is required", null)
                            }
                        } catch (e: Exception) {
                            result.error("ADD_WIDGET_ERROR", e.message, null)
                        }
                    }

                    "removeWidget" -> {
                        try {
                            val widgetId = call.argument<Int>("widgetId")
                            if (widgetId != null) {
                                appWidgetHost.deleteAppWidgetId(widgetId)
                                result.success(null)
                            } else {
                                result.error("INVALID_ARGS", "Widget ID is required", null)
                            }
                        } catch (e: Exception) {
                            result.error("REMOVE_WIDGET_ERROR", e.message, null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun startWidgetHost() {
        if (!isWidgetHostStarted) {
            try {
                appWidgetHost.startListening()
                isWidgetHostStarted = true
                Log.d("WidgetDebug", "Widget host started successfully")
            } catch (e: Exception) {
                Log.e("WidgetDebug", "Error starting widget host: ${e.message}")
                // Don't throw - just log the error
            }
        }
    }

    private fun stopWidgetHost() {
        if (isWidgetHostStarted) {
            try {
                appWidgetHost.stopListening()
                isWidgetHostStarted = false
                Log.d("WidgetDebug", "Widget host stopped successfully")
            } catch (e: Exception) {
                Log.e("WidgetDebug", "Error stopping widget host: ${e.message}")
                // Don't throw - just log the error
            }
        }
    }

    private fun getAvailableWidgets(): List<Map<String, Any>> {
        return providers.map { provider ->
            mapOf(
                "id" to provider.provider.toString(), // Return full provider component name
                "label" to provider.loadLabel(packageManager),
                "previewImage" to provider.previewImage,
                "minWidth" to provider.minWidth,
                "minHeight" to provider.minHeight
            )
        }
    }

    private fun addWidget(providerId: String, result: MethodChannel.Result) {
        try {
            // Find the provider with matching ID
            val provider = providers.find { it.provider.toString() == providerId }
            if (provider == null) {
                result.error("INVALID_PROVIDER", "Provider not found: $providerId", null)
                return
            }

            lastAllocatedWidgetId = appWidgetHost.allocateAppWidgetId()

            // Ensure host is listening
            if (!isWidgetHostStarted) {
                startWidgetHost()
            }

            pendingResults[lastAllocatedWidgetId] = result

            val bindIntent = Intent(AppWidgetManager.ACTION_APPWIDGET_BIND).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, lastAllocatedWidgetId)
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_PROVIDER, provider.provider)
            }

            startActivityForResult(bindIntent, REQUEST_BIND_WIDGET)
            Log.d("WidgetDebug", "Started binding process for widget ID: $lastAllocatedWidgetId")

        } catch (e: Exception) {
            Log.e("WidgetDebug", "Error in addWidget", e)
            result.error("WIDGET_ERROR", e.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_BIND_WIDGET) {
            val widgetId = data?.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                lastAllocatedWidgetId
            ) ?: lastAllocatedWidgetId

            val result = pendingResults.remove(widgetId) ?: return

            when (resultCode) {
                Activity.RESULT_OK -> {
                    val widgetInfo = appWidgetManager.getAppWidgetInfo(widgetId)
                    if (widgetInfo != null) {
                        result.success(widgetId)
                    } else {
                        appWidgetHost.deleteAppWidgetId(widgetId)
                        result.error("BIND_FAILED", "Widget binding verification failed", null)
                    }
                }

                Activity.RESULT_CANCELED -> {
                    appWidgetHost.deleteAppWidgetId(widgetId)
                    result.error("BIND_CANCELLED", "Widget binding cancelled by user", null)
                }

                else -> {
                    appWidgetHost.deleteAppWidgetId(widgetId)
                    result.error("BIND_FAILED", "Failed to bind widget", null)
                }
            }
        }
    }

    override fun onDestroy() {
        stopWidgetHost()
        super.onDestroy()
    }
}