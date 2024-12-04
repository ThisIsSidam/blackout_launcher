import 'package:blackout_launcher/database/added_widgets_db.dart';
import 'package:blackout_launcher/models/widgets/added_widget_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/widget_manager/widget_manager_provider.dart';
import '../../../models/widgets/widget_info.dart';

class WidgetState extends StateNotifier<List<AddedWidgetInfo>> {
  WidgetState() : super(AddedWidgetsDB.getWidgets(WidgetSlot.leftDrawer) ?? []);

  Future<void> addWidget(WidgetInfo widget) async {
    try {
      // Request a new widget instance from the platform
      final appWidgetId = await WidgetManager.addWidget(widget.providerId);

      if (appWidgetId != null) {
        final AddedWidgetInfo newWidget = AddedWidgetInfo.fromWidgetInfo(
            widgetInfo: widget, appWidgetId: appWidgetId);

        state = [...state, newWidget];
        AddedWidgetsDB.addWidget(WidgetSlot.leftDrawer, newWidget);
      } else {
        print('Failed to get appWidgetId from platform');
      }
    } catch (e) {
      print('Error in addWidget: $e');
    }
  }

  void reorderWidgets(int oldIndex, int newIndex) {
    final widgets = [...state];
    final item = widgets.removeAt(oldIndex);
    widgets.insert(newIndex, item);
    state = widgets;
    AddedWidgetsDB.updateWidgets(WidgetSlot.leftDrawer, state);
  }

  void removeWidget(int id) {
    final widgetToRemove =
        state.firstWhere((widget) => widget.appWidgetId == id);

    // If the widget has an appWidgetId, you might want to clean it up on the platform side
    WidgetManager.removeWidget(widgetToRemove.appWidgetId);

    state = state.where((widget) => widget.appWidgetId != id).toList();
    AddedWidgetsDB.removeWidget(WidgetSlot.leftDrawer, id);
  }
}

final widgetStateProvider =
    StateNotifierProvider<WidgetState, List<AddedWidgetInfo>>((ref) {
  return WidgetState();
});
