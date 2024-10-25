import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/widget_manager/widget_manager_provider.dart';

class WidgetState extends StateNotifier<List<WidgetInfo>> {
  WidgetState() : super([]);

  Future<void> addWidget(WidgetInfo widget) async {
    // Get the index of the widget in the available widgets list
    final widgetIndex =
        state.length; // Or however you want to determine the index

    // Request a new widget instance from the platform
    final appWidgetId = await WidgetManager.addWidget(widgetIndex);

    if (appWidgetId != null) {
      // Create new widget info with the assigned appWidgetId
      final newWidget = WidgetInfo(
        id: widget.id,
        label: widget.label,
        previewImage: widget.previewImage,
        minWidth: widget.minWidth,
        minHeight: widget.minHeight,
        appWidgetId: appWidgetId,
      );

      state = [...state, newWidget];
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
      // You could add a method to WidgetManager to handle this:
      // await WidgetManager.removeWidget(widgetToRemove.appWidgetId!);
    }

    state = state.where((widget) => widget.id != id).toList();
  }
}

final widgetStateProvider =
    StateNotifierProvider<WidgetState, List<WidgetInfo>>((ref) {
  return WidgetState();
});
