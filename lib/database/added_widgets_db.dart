import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:blackout_launcher/models/widgets/added_widget_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum WidgetSlot {
  leftDrawer('Left Drawer', 'left_drawer_key');

  final String name;
  final String key;

  const WidgetSlot(this.name, this.key);
}

class AddedWidgetsDB {
  static final _box = Hive.box<List>(HiveBoxNames.addedWidgets.name);

  static List<AddedWidgetInfo>? getWidgets(WidgetSlot slot) {
    final List? data = _box.get(slot.key);
    return data?.cast<AddedWidgetInfo>() ?? [];
  }

  static void addWidget(WidgetSlot slot, AddedWidgetInfo widget) {
    final List<AddedWidgetInfo>? widgets = getWidgets(slot);
    if (widgets == null) {
      _box.put(slot.key, [widget]);
      return;
    }
    widgets.add(widget);
    _box.put(slot.key, widgets);
  }

  static void removeWidget(WidgetSlot slot, int appWidgetId) {
    final List<AddedWidgetInfo>? widgets = getWidgets(slot);
    if (widgets == null) return;
    widgets.removeWhere((e) => e.appWidgetId == appWidgetId);
    _box.put(slot.key, widgets);
  }
}
