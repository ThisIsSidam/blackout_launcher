import 'package:blackout_launcher/models/widgets/added_widget_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../feature/widget_manager/widget_manager_provider.dart';
import '../../providers/widget_state_provider.dart';
import 'available_widgets_sheet.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final List<AddedWidgetInfo> widgets = ref.watch(widgetStateProvider);

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: isEditing
                  ? _buildEditableWidgetList(widgets)
                  : _buildWidgetList(widgets),
            ),
            if (isEditing) _buildAddWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, top: MediaQuery.sizeOf(context).height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Widgets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.done : Icons.edit),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetList(List<AddedWidgetInfo> widgets) {
    return ListView.separated(
      itemCount: widgets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return WidgetContainer(
          widget: widgets[index],
        );
      },
    );
  }

  Widget _buildEditableWidgetList(List<AddedWidgetInfo> widgets) {
    return ReorderableListView.builder(
      itemCount: widgets.length,
      onReorder: (oldIndex, newIndex) {
        ref
            .read(widgetStateProvider.notifier)
            .reorderWidgets(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final widget = widgets[index];
        return Row(
          key: ValueKey('row-$index-${widget.appWidgetId}'),
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_indicator),
            ),
            Flexible(
              child: EditableWidgetTile(
                key: ValueKey(widget.appWidgetId),
                widget: widget,
                onRemove: () {
                  ref
                      .read(widgetStateProvider.notifier)
                      .removeWidget(widget.appWidgetId);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddWidgetButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add Widget'),
        onPressed: () => _showWidgetPicker(context),
      ),
    );
  }

  Future<void> _showWidgetPicker(BuildContext context) async {
    final availableWidgets = await WidgetManager.getAvailableWidgets();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => AvailableWidgetsSheet(
        widgets: availableWidgets,
        onWidgetSelected: (widget) async {
          await ref.read(widgetStateProvider.notifier).addWidget(widget);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// Update your WidgetContainer class
class WidgetContainer extends StatelessWidget {
  final AddedWidgetInfo widget;

  const WidgetContainer({
    required this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.primary),
        constraints: BoxConstraints(
          minWidth: widget.minWidth.toDouble(),
          minHeight: widget.minHeight.toDouble(),
        ),
        child: AndroidWidget(
          widgetId: widget.appWidgetId,
          width: widget.minWidth.toDouble(),
          height: widget.minHeight.toDouble(),
        ));
  }
}

class AndroidWidget extends StatefulWidget {
  final int widgetId;
  final double width;
  final double height;

  const AndroidWidget({
    required this.widgetId,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  State<AndroidWidget> createState() => _AndroidWidgetState();
}

class _AndroidWidgetState extends State<AndroidWidget> {
  @override
  Widget build(BuildContext context) {
    // Use AndroidView to display the native widget
    print('Building AndroidWidget with ID: ${widget.widgetId}');
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AndroidView(
        viewType: 'android-widget-view',
        layoutDirection: TextDirection.ltr,
        creationParams: {'widgetId': widget.widgetId},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int viewId) {
          print('Android widget view created: $viewId');
        },
      ),
    );
  }
}

class EditableWidgetTile extends StatelessWidget {
  final AddedWidgetInfo widget;
  final VoidCallback onRemove;

  const EditableWidgetTile({
    required this.widget,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(widget.label,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        IconButton(
          icon: Icon(Icons.tune),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onRemove,
          color: Colors.red,
        ),
      ],
    );
  }
}
