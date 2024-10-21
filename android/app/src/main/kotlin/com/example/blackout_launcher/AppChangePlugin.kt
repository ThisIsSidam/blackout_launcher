package com.example.blackout_launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class AppChangePlugin(private val context: Context, flutterEngine: FlutterEngine) : FlutterPlugin,
    ActivityAware {
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var streamHandler: AppChangeStreamHandler? = null

    init {
        setupChannels(flutterEngine)
    }

    private fun setupChannels(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.blackout.launcher/app_changes"
        )

        eventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.blackout.launcher/app_change_events"
        )

        streamHandler = AppChangeStreamHandler(context)
        eventChannel?.setStreamHandler(streamHandler)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Not used in this context but required by FlutterPlugin
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        cleanup()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // Not used in this context but required by ActivityAware
    }

    override fun onDetachedFromActivity() {
        cleanup()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // Not used in this context but required by ActivityAware
    }

    override fun onDetachedFromActivityForConfigChanges() {
        cleanup()
    }

    fun cleanup() {
        streamHandler?.cleanup()
        methodChannel?.setMethodCallHandler(null)
        eventChannel?.setStreamHandler(null)
        methodChannel = null
        eventChannel = null
        streamHandler = null
    }
}

class AppChangeStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null
    private var isRegistered = false

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (isRegistered) {
            cleanup()
        }

        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val packageName = intent?.data?.schemeSpecificPart
                when (intent?.action) {
                    Intent.ACTION_PACKAGE_ADDED -> {
                        events?.success(
                            mapOf(
                                "event" to "installed",
                                "package" to packageName
                            )
                        )
                    }

                    Intent.ACTION_PACKAGE_REMOVED -> {
                        events?.success(
                            mapOf(
                                "event" to "uninstalled",
                                "package" to packageName
                            )
                        )
                    }
                }
            }
        }

        val intentFilter = IntentFilter().apply {
            addAction(Intent.ACTION_PACKAGE_ADDED)
            addAction(Intent.ACTION_PACKAGE_REMOVED)
            addDataScheme("package")
        }

        try {
            context.registerReceiver(receiver, intentFilter)
            isRegistered = true
        } catch (e: Exception) {
            events?.error("RECEIVER_ERROR", "Failed to register receiver", e.message)
        }
    }

    override fun onCancel(arguments: Any?) {
        cleanup()
    }

    fun cleanup() {
        if (isRegistered) {
            try {
                context.unregisterReceiver(receiver)
            } catch (e: Exception) {
                // Handle or log any unregister errors
            }
            isRegistered = false
        }
        receiver = null
    }
}