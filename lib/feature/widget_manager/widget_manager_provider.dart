import 'package:flutter/services.dart';

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

  static Future<int?> addWidget(int providerId) async {
    try {
      final int widgetId =
          await platform.invokeMethod('addWidget', {'widgetId': providerId});
      return widgetId;
    } on PlatformException catch (e) {
      print('Error adding widget: ${e.message}');
      return null;
    }
  }
}

class WidgetInfo {
  final String id;
  final String label;
  final int previewImage;
  final int minWidth;
  final int minHeight;

  WidgetInfo({
    required this.id,
    required this.label,
    required this.previewImage,
    required this.minWidth,
    required this.minHeight,
  });

  factory WidgetInfo.fromMap(Map<String, dynamic> map) {
    return WidgetInfo(
      id: map['id'],
      label: map['label'],
      previewImage: map['previewImage'],
      minWidth: map['minWidth'],
      minHeight: map['minHeight'],
    );
  }
}
