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

class WidgetInfo {
  final String id; // This is the provider ID (provider.provider.shortClassName)
  final String label;
  final int previewImage;
  final int minWidth;
  final int minHeight;
  final int? appWidgetId; // The platform-assigned widget instance ID

  WidgetInfo({
    required this.id,
    required this.label,
    required this.previewImage,
    required this.minWidth,
    required this.minHeight,
    this.appWidgetId,
  });

  factory WidgetInfo.fromMap(Map<String, dynamic> map) {
    return WidgetInfo(
      id: map['id'],
      label: map['label'],
      previewImage: map['previewImage'],
      minWidth: map['minWidth'],
      minHeight: map['minHeight'],
      appWidgetId: map['appWidgetId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'previewImage': previewImage,
      'minWidth': minWidth,
      'minHeight': minHeight,
      'appWidgetId': appWidgetId,
    };
  }

  // Helper method to create a copy with an appWidgetId
  WidgetInfo copyWithAppWidgetId(int id) {
    return WidgetInfo(
      id: this.id,
      label: this.label,
      previewImage: this.previewImage,
      minWidth: this.minWidth,
      minHeight: this.minHeight,
      appWidgetId: id,
    );
  }
}
