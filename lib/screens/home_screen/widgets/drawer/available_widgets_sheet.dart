import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../models/widgets/widget_info.dart';

class AvailableWidgetsSheet extends StatelessWidget {
  final List<WidgetInfo> widgets;
  final Function(WidgetInfo) onWidgetSelected;

  const AvailableWidgetsSheet({
    required this.widgets,
    required this.onWidgetSelected,
    super.key,
  });

  // Previous methods remain the same...
  // _loadPreviewImage and other helper methods...

  Widget _buildPreviewImage(int previewImage, String providerId) {
    if (previewImage == 0) {
      return const SizedBox(
        width: 120, // Increased size
        height: 120, // Increased size
        child: Icon(
          Icons.widgets_outlined,
          size: 48, // Larger icon
        ),
      );
    }

    return FutureBuilder<Uint8List?>(
      future: _loadPreviewImage(previewImage, providerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120, // Match the size
            width: 120, // Match the size
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (snapshot.hasError) {
            debugPrint('Error loading preview image: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            debugPrint('Preview image data is null');
          }
          return const SizedBox(
            width: 120, // Match the size
            height: 120, // Match the size
            child: Icon(
              Icons.error_outline,
              size: 48, // Larger icon
            ),
          );
        }

        return Image.memory(
          snapshot.data!,
          width: 120, // Larger preview
          height: 120, // Larger preview
          fit: BoxFit.contain,
        );
      },
    );
  }

  Future<Uint8List?> _loadPreviewImage(
      int previewImage, String providerId) async {
    try {
      const platform = MethodChannel('com.example.app/widgets');
      final Uint8List? imageData = await platform.invokeMethod<Uint8List>(
        'loadWidgetPreviewImage',
        {
          'previewImage': previewImage,
          'providerId': providerId,
        },
      );
      return imageData;
    } catch (e) {
      debugPrint('Error loading preview image: $e');
      return null;
    }
  }

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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                final widget = widgets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildWidgetContainer(
                    context,
                    widget.label,
                    widget.previewImage,
                    widget.providerId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetContainer(
      BuildContext context, String label, int previewImage, String providerId) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget Name
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          // Widget Preview Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Center(
              child: _buildPreviewImage(previewImage, providerId),
            ),
          ),
        ],
      ),
    );
  }
}
