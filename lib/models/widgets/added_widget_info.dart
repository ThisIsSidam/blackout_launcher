import 'package:blackout_launcher/models/widgets/widget_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'added_widget_info.freezed.dart';
part 'added_widget_info.g.dart';

@HiveType(typeId: 1)
@freezed
class AddedWidgetInfo with _$AddedWidgetInfo {
  @JsonSerializable(explicitToJson: true)
  const factory AddedWidgetInfo({
    @HiveField(0) required String providerId,
    @HiveField(1) required int appWidgetId,
    @HiveField(2) required int userGivenHeight,
    @HiveField(3) required int userGivenWidth,
    @HiveField(4) required String label,
    @HiveField(5) required int previewImage,
    @HiveField(6) required int minWidth,
    @HiveField(7) required int minHeight,
  }) = _AddedWidgetInfo;

  factory AddedWidgetInfo.fromJson(Map<String, dynamic> json) =>
      _$AddedWidgetInfoFromJson(json);

  factory AddedWidgetInfo.fromWidgetInfo({
    required WidgetInfo widgetInfo,
    required int appWidgetId,
  }) {
    return AddedWidgetInfo(
      providerId: widgetInfo.providerId,
      appWidgetId: appWidgetId,
      userGivenHeight: widgetInfo.minHeight,
      userGivenWidth: widgetInfo.minWidth,
      label: widgetInfo.label,
      previewImage: widgetInfo.previewImage,
      minWidth: widgetInfo.minWidth,
      minHeight: widgetInfo.minHeight,
    );
  }
}
