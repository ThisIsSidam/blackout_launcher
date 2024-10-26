class WidgetInfo {
  final String providerId; // Ex: provider.provider.shortClassName
  final String label;
  final int previewImage;
  final int minWidth;
  final int minHeight;

  WidgetInfo({
    required this.providerId,
    required this.label,
    required this.previewImage,
    required this.minWidth,
    required this.minHeight,
  });

  factory WidgetInfo.fromMap(Map<String, dynamic> map) {
    return WidgetInfo(
      providerId: map['id'],
      label: map['label'],
      previewImage: map['previewImage'],
      minWidth: map['minWidth'],
      minHeight: map['minHeight'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': providerId,
      'label': label,
      'previewImage': previewImage,
      'minWidth': minWidth,
      'minHeight': minHeight,
    };
  }
}
