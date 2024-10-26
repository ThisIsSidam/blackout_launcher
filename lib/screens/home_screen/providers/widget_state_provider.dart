import 'package:blackout_launcher/models/widgets/added_widget_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/widget_manager/widget_manager_provider.dart';
import '../../../models/widgets/widget_info.dart';

class WidgetState extends StateNotifier<List<AddedWidgetInfo>> {
  WidgetState() : super([]);

  Future<void> addWidget(WidgetInfo widget) async {
    try {
      // Get the index of the widget in the available widgets list
      final widgetIndex = state.length;

      // Request a new widget instance from the platform
      final appWidgetId = await WidgetManager.addWidget(widget.providerId);

      if (appWidgetId != null) {
        final AddedWidgetInfo newWidget = AddedWidgetInfo.fromWidgetInfo(
            widgetInfo: widget, appWidgetId: appWidgetId);

        state = [...state, newWidget];
      } else {
        print('Failed to get appWidgetId from platform');
      }
    } catch (e) {
      print('Error in addWidget: $e');
    }
  }

  void reorderWidgets(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final widgets = [...state];
    final item = widgets.removeAt(oldIndex);
    widgets.insert(newIndex, item);
    state = widgets;
  }

  void removeWidget(int id) {
    final widgetToRemove =
        state.firstWhere((widget) => widget.appWidgetId == id);

    // If the widget has an appWidgetId, you might want to clean it up on the platform side
    if (widgetToRemove.appWidgetId != null) {
      WidgetManager.removeWidget(widgetToRemove.appWidgetId!);
    }

    state = state.where((widget) => widget.appWidgetId != id).toList();
  }
}

final widgetStateProvider =
    StateNotifierProvider<WidgetState, List<AddedWidgetInfo>>((ref) {
  return WidgetState();
});
