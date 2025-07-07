// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 1;

  @override
  PostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      userDisplayName: fields[2] as String,
      userAvatarUrl: fields[3] as String?,
      title: fields[4] as String,
      description: fields[5] as String,
      imageUrls: (fields[6] as List).cast<String>(),
      category: fields[7] as String,
      type: fields[8] as PostType,
      price: fields[9] as double?,
      location: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      likesCount: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userDisplayName)
      ..writeByte(3)
      ..write(obj.userAvatarUrl)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.imageUrls)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.likesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostTypeAdapter extends TypeAdapter<PostType> {
  @override
  final int typeId = 0;

  @override
  PostType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PostType.offer;
      case 1:
        return PostType.request;
      case 2:
        return PostType.general;
      default:
        return PostType.offer;
    }
  }

  @override
  void write(BinaryWriter writer, PostType obj) {
    switch (obj) {
      case PostType.offer:
        writer.writeByte(0);
        break;
      case PostType.request:
        writer.writeByte(1);
        break;
      case PostType.general:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
