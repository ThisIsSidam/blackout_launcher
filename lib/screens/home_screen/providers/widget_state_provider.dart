import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/widget_manager/widget_manager_provider.dart';

class WidgetState extends StateNotifier<List<WidgetInfo>> {
  WidgetState() : super([]);

  void addWidget(WidgetInfo widget) {
    state = [...state, widget];
  }

  void reorderWidgets(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state = [...state]..insert(newIndex, item);
  }

  void removeWidget(String id) {
    state = state.where((widget) => widget.id != id).toList();
  }
}

final widgetStateProvider =
    StateNotifierProvider<WidgetState, List<WidgetInfo>>((ref) {
  return WidgetState();
});
