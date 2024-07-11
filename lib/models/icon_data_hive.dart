import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final typeId = 1;

  @override
  IconData read(BinaryReader reader) {
    final codePoint = reader.readInt();
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer.writeInt(obj.codePoint);
  }
}
