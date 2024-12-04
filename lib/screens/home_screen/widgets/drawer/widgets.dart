import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../models/widgets/added_widget_info.dart';

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
      ),
    );
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primaryContainer),
      constraints: BoxConstraints(
        minWidth: widget.minWidth.toDouble(),
        minHeight: widget.minHeight.toDouble(),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Column(
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemove,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
