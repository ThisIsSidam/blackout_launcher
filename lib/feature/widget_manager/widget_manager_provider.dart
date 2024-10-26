import 'package:flutter/services.dart';

import '../../models/widgets/widget_info.dart';

class WidgetManager {
  static const platform = MethodChannel('com.example.app/widgets');

  static Future<List<WidgetInfo>> getAvailableWidgets() async {
    try {
      final List result = await platform.invokeMethod('getAvailableWidgets');
      return result
          .map((widget) => WidgetInfo.fromMap(
              Map<String, dynamic>.from(widget as Map<Object?, Object?>)))
          .toList();
    } on PlatformException catch (e) {
      print('Error getting widgets: ${e.message}');
      return [];
    }
  }

  static Future<int?> addWidget(String providerId) async {
    try {
      final int? appWidgetId = await platform.invokeMethod('addWidget', {
        'providerId': providerId // Pass the provider ID string
      });
      return appWidgetId;
    } catch (e) {
      print('Error adding widget: $e');
      return null;
    }
  }

  static Future<void> removeWidget(int widgetId) async {
    try {
      await platform.invokeMethod('removeWidget', {'widgetId': widgetId});
    } on PlatformException catch (e) {
      print('Error removing widget: ${e.message}');
    }
  }
}
