// AndroidWidgetView.kt
package com.example.blackout_launcher

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetHostView
import android.appwidget.AppWidgetManager
import android.content.Context
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class AndroidWidgetView(
    private val context: Context,
    private val appWidgetHost: AppWidgetHost,
    private val appWidgetManager: AppWidgetManager,
    private val appWidgetId: Int
) : PlatformView {
    private var hostView: AppWidgetHostView? = null

    init {
        hostView = appWidgetHost.createView(
            context, appWidgetId,
            appWidgetManager.getAppWidgetInfo(appWidgetId)
        )
        appWidgetHost.startListening()
    }

    override fun getView(): View? = hostView

    override fun dispose() {
        hostView = null
    }
}

class AndroidWidgetViewFactory(
    private val appWidgetHost: AppWidgetHost,
    private val appWidgetManager: AppWidgetManager
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<*, *>
        val appWidgetId = (params["widgetId"] as Int)
        return AndroidWidgetView(context, appWidgetHost, appWidgetManager, appWidgetId)
    }
}