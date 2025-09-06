// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 0;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      name: fields[1] as String,
      alternate: fields[2] as String?,
      category: fields[3] as String,
      area: fields[4] as String,
      instructions: fields[5] as String,
      thumbnail: fields[6] as String,
      tags: fields[7] as String?,
      youtube: fields[8] as String,
      ingredients: (fields[9] as List).cast<MealIngredient>(),
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.alternate)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.area)
      ..writeByte(5)
      ..write(obj.instructions)
      ..writeByte(6)
      ..write(obj.thumbnail)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.youtube)
      ..writeByte(9)
      ..write(obj.ingredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealIngredientAdapter extends TypeAdapter<MealIngredient> {
  @override
  final int typeId = 1;

  @override
  MealIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealIngredient(
      name: fields[0] as String,
      measure: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MealIngredient obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.measure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealShortAdapter extends TypeAdapter<MealShort> {
  @override
  final int typeId = 2;

  @override
  MealShort read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealShort(
      id: fields[0] as String,
      name: fields[1] as String,
      thumbnail: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MealShort obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealShortAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
