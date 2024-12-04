import 'package:blackout_launcher/models/widgets/added_widget_info.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/drawer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/widget_state_provider.dart';
import 'available_widgets_sheet.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends ConsumerState<HomeDrawer> {
  final ValueNotifier<bool> isEditingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final List<AddedWidgetInfo> widgets = ref.watch(widgetStateProvider);

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ValueListenableBuilder(
          valueListenable: isEditingNotifier,
          builder: (context, bool isEditing, _) {
            return Column(
              children: [
                SizedBox(height: isEditing ? 32 : 8),
                Expanded(
                  child: AnimatedCrossFade(
                    firstChild: _buildEditableWidgetList(widgets),
                    secondChild: _buildWidgetList(widgets),
                    crossFadeState: isEditing
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(
                      milliseconds: 100,
                    ),
                  ),
                ),
                if (isEditing) _buildBottomSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWidgetList(List<AddedWidgetInfo> widgets) {
    if (widgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: Text('No widgets added')),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(
                'Add Widget',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              onPressed: () => _showNewWidgetPicker(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: widgets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return InkWell(
          onLongPress: () => isEditingNotifier.value = !isEditingNotifier.value,
          child: WidgetContainer(
            widget: widgets[index],
          ),
        );
      },
    );
  }

  Widget _buildEditableWidgetList(
    List<AddedWidgetInfo> widgets,
  ) {
    return ReorderableListView.builder(
      proxyDecorator: (child, index, animation) {
        return Material(
          type: MaterialType.transparency,
          child: child,
        );
      },
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

  Widget _buildBottomSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(
              'Add Widget',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            onPressed: () => _showNewWidgetPicker(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(12),
                  right: Radius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.done),
            onPressed: () => isEditingNotifier.value = false,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(4),
                  right: Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showNewWidgetPicker() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => AvailableWidgetsSheet(
        onWidgetSelected: (widget) async {
          await ref.read(widgetStateProvider.notifier).addWidget(widget);
        },
      ),
    );
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
