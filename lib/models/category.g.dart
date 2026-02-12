// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.food;
      case 1:
        return Category.travel;
      case 2:
        return Category.shopping;
      case 3:
        return Category.bills;
      case 4:
        return Category.education;
      case 5:
        return Category.atm;
      case 6:
        return Category.income;
      case 7:
        return Category.other;
      default:
        return Category.food;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.food:
        writer.writeByte(0);
        break;
      case Category.travel:
        writer.writeByte(1);
        break;
      case Category.shopping:
        writer.writeByte(2);
        break;
      case Category.bills:
        writer.writeByte(3);
        break;
      case Category.education:
        writer.writeByte(4);
        break;
      case Category.atm:
        writer.writeByte(5);
        break;
      case Category.income:
        writer.writeByte(6);
        break;
      case Category.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
