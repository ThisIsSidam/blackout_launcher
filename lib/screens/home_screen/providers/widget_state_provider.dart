import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/widget_manager/widget_manager_provider.dart';

class WidgetState extends StateNotifier<List<WidgetInfo>> {
  WidgetState() : super([]);

  Future<void> addWidget(WidgetInfo widget) async {
    try {
      // Get the index of the widget in the available widgets list
      final widgetIndex = state.length;

      // Request a new widget instance from the platform
      final appWidgetId = await WidgetManager.addWidget(widget.id);

      if (appWidgetId != null) {
        // Create new widget info with the assigned appWidgetId
        final newWidget = widget.copyWithAppWidgetId(appWidgetId);

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

  void removeWidget(String id) {
    final widgetToRemove = state.firstWhere((widget) => widget.id == id);

    // If the widget has an appWidgetId, you might want to clean it up on the platform side
    if (widgetToRemove.appWidgetId != null) {
      WidgetManager.removeWidget(widgetToRemove.appWidgetId!);
    }

    state = state.where((widget) => widget.id != id).toList();
  }
}

final widgetStateProvider =
    StateNotifierProvider<WidgetState, List<WidgetInfo>>((ref) {
  return WidgetState();
});
