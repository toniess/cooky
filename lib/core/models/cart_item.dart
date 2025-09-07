import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 3)
class CartItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String measure;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final int quantity;
  @HiveField(5)
  final String mealId; // ID рецепта, из которого взят ингредиент
  @HiveField(6)
  final String mealName; // Название рецепта для отображения
  @HiveField(7)
  final bool isPurchased; // Отмечен ли товар как купленный

  CartItem({
    required this.id,
    required this.name,
    required this.measure,
    required this.imageUrl,
    this.quantity = 1,
    required this.mealId,
    required this.mealName,
    this.isPurchased = false,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? measure,
    String? imageUrl,
    int? quantity,
    String? mealId,
    String? mealName,
    bool? isPurchased,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      measure: measure ?? this.measure,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      mealId: mealId ?? this.mealId,
      mealName: mealName ?? this.mealName,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, measure: $measure, quantity: $quantity)';
  }
}
