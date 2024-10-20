package com.example.blackout_launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class AppChangePlugin(private val context: Context, flutterEngine: FlutterEngine) {
    private val methodChannel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "com.blackout.launcher/app_changes"
    )
    private val eventChannel = EventChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "com.blackout.launcher/app_change_events"
    )

    init {
        eventChannel.setStreamHandler(AppChangeStreamHandler(context))
    }
}

class AppChangeStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
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
        context.registerReceiver(receiver, intentFilter)
    }

    override fun onCancel(arguments: Any?) {
        receiver?.let { context.unregisterReceiver(it) }
        receiver = null
    }
}