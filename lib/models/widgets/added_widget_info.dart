// This class is used for widgets that the user has added.
// It does not contain the general minWidth, minHeight and more.
// Only general information is the provider id, which the user can use to
// search the WidgetInfo object of this widget and get the general info.
import 'package:blackout_launcher/models/widgets/widget_info.dart';

class AddedWidgetInfo {
  final String providerId;
  final int appWidgetId;
  final int userGivenHeight;
  final int userGivenWidth;
  final String label;
  final int previewImage;
  final int minWidth;
  final int minHeight;

  const AddedWidgetInfo({
    required this.providerId,
    required this.appWidgetId,
    required this.userGivenHeight,
    required this.userGivenWidth,
    required this.label,
    required this.previewImage,
    required this.minWidth,
    required this.minHeight,
  });

  AddedWidgetInfo.fromWidgetInfo({
    required WidgetInfo widgetInfo,
    required this.appWidgetId,
  })  : providerId = widgetInfo.providerId,
        userGivenHeight = widgetInfo.minHeight,
        userGivenWidth = widgetInfo.minWidth,
        label = widgetInfo.label,
        previewImage = widgetInfo.previewImage,
        minWidth = widgetInfo.minWidth,
        minHeight = widgetInfo.minHeight;

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'appWidgetId': appWidgetId,
      'userGivenHeight': userGivenHeight,
      'userGivenWidth': userGivenWidth,
      'label': label,
      'previewImage': previewImage,
      'minWidth': minWidth,
      'minHeight': minHeight,
    };
  }

  factory AddedWidgetInfo.fromMap(Map<String, dynamic> map) {
    return AddedWidgetInfo(
      providerId: map['providerId'],
      appWidgetId: map['appWidgetId'],
      userGivenHeight: map['userGivenHeight'],
      userGivenWidth: map['userGivenWidth'],
      label: map['label'],
      previewImage: map['previewImage'],
      minWidth: map['minWidth'],
      minHeight: map['minHeight'],
    );
  }
}
