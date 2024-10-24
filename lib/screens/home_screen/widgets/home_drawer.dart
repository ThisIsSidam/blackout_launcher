import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/widget_manager/widget_manager_provider.dart';
import '../providers/widget_state_provider.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final widgets = ref.watch(widgetStateProvider);

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
    return Row(
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
    );
  }

  Widget _buildWidgetList(List<WidgetInfo> widgets) {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return WidgetContainer(widget: widgets[index]);
      },
    );
  }

  Widget _buildEditableWidgetList(List<WidgetInfo> widgets) {
    return ReorderableListView.builder(
      itemCount: widgets.length,
      onReorder: (oldIndex, newIndex) {
        ref
            .read(widgetStateProvider.notifier)
            .reorderWidgets(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final widget = widgets[index];
        return EditableWidgetContainer(
          key: ValueKey(widget.id),
          widget: widget,
          onRemove: () {
            ref.read(widgetStateProvider.notifier).removeWidget(widget.id);
          },
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
        onWidgetSelected: (widget) {
          ref.read(widgetStateProvider.notifier).addWidget(widget);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class WidgetContainer extends StatelessWidget {
  final WidgetInfo widget;

  const WidgetContainer({
    required this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        constraints: BoxConstraints(
          minWidth: widget.minWidth.toDouble(),
          minHeight: widget.minHeight.toDouble(),
        ),
        child: Center(
          child: Text(widget.label), // Replace with actual widget rendering
        ),
      ),
    );
  }
}

class EditableWidgetContainer extends StatelessWidget {
  final WidgetInfo widget;
  final VoidCallback onRemove;

  const EditableWidgetContainer({
    required this.widget,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WidgetContainer(widget: widget),
        Positioned(
          right: 4,
          top: 4,
          child: IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: onRemove,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class AvailableWidgetsSheet extends StatelessWidget {
  final List<WidgetInfo> widgets;
  final Function(WidgetInfo) onWidgetSelected;

  const AvailableWidgetsSheet({
    required this.widgets,
    required this.onWidgetSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Available Widgets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                final widget = widgets[index];
                return ListTile(
                  title: Text(widget.label),
                  onTap: () => onWidgetSelected(widget),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
