// AndroidWidgetView.kt
package com.example.blackout_launcher

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetHostView
import android.appwidget.AppWidgetManager
import android.content.Context
import android.util.Log
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
        try {
            Log.d("AndroidWidgetView", "Creating view for widget ID: $appWidgetId")
            val widgetInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)
            Log.d("AndroidWidgetView", "Widget info: $widgetInfo")

            hostView = appWidgetHost.createView(
                context,
                appWidgetId,
                widgetInfo
            )
            Log.d("AndroidWidgetView", "HostView created successfully")

        } catch (e: Exception) {
            Log.e("AndroidWidgetView", "Error creating widget view", e)
        }
    }

    override fun getView(): View? {
        if (hostView == null) {
            Log.e("AndroidWidgetView", "hostView is null")
        }
        return hostView
    }

    override fun dispose() {
        Log.d("AndroidWidgetView", "Disposing widget view for ID: $appWidgetId")
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
        Log.d("AndroidWidgetViewFactory", "Creating widget view with ID: $appWidgetId")
        return AndroidWidgetView(context, appWidgetHost, appWidgetManager, appWidgetId)
    }

}