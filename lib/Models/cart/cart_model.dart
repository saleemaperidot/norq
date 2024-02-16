import 'package:hive_flutter/hive_flutter.dart';
part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String price;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String image;
  @HiveField(5)
  final int count;

  CartModel(
      {required this.id,
      required this.price,
      required this.count,
      required this.description,
      required this.image,
      required this.title});
  CartModel incrementCount(int countvalue) {
    return CartModel(
        id: this.id,
        price: this.price,
        count: countvalue,
        description: this.description,
        image: this.image,
        title: this.title);
  }
}
