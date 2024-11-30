// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'added_widget_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddedWidgetInfoAdapter extends TypeAdapter<AddedWidgetInfo> {
  @override
  final int typeId = 1;

  @override
  AddedWidgetInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddedWidgetInfo(
      providerId: fields[0] as String,
      appWidgetId: fields[1] as int,
      userGivenHeight: fields[2] as int,
      userGivenWidth: fields[3] as int,
      label: fields[4] as String,
      previewImage: fields[5] as int,
      minWidth: fields[6] as int,
      minHeight: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AddedWidgetInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.providerId)
      ..writeByte(1)
      ..write(obj.appWidgetId)
      ..writeByte(2)
      ..write(obj.userGivenHeight)
      ..writeByte(3)
      ..write(obj.userGivenWidth)
      ..writeByte(4)
      ..write(obj.label)
      ..writeByte(5)
      ..write(obj.previewImage)
      ..writeByte(6)
      ..write(obj.minWidth)
      ..writeByte(7)
      ..write(obj.minHeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddedWidgetInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddedWidgetInfoImpl _$$AddedWidgetInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$AddedWidgetInfoImpl(
      providerId: json['providerId'] as String,
      appWidgetId: (json['appWidgetId'] as num).toInt(),
      userGivenHeight: (json['userGivenHeight'] as num).toInt(),
      userGivenWidth: (json['userGivenWidth'] as num).toInt(),
      label: json['label'] as String,
      previewImage: (json['previewImage'] as num).toInt(),
      minWidth: (json['minWidth'] as num).toInt(),
      minHeight: (json['minHeight'] as num).toInt(),
    );

Map<String, dynamic> _$$AddedWidgetInfoImplToJson(
        _$AddedWidgetInfoImpl instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'appWidgetId': instance.appWidgetId,
      'userGivenHeight': instance.userGivenHeight,
      'userGivenWidth': instance.userGivenWidth,
      'label': instance.label,
      'previewImage': instance.previewImage,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
    };
