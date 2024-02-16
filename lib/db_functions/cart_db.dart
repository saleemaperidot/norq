import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/Models/cart/cart_model.dart';

const CART_DB_NAME = 'category_db';

abstract class CartdbFunction {
  Future<List<CartModel>> getCart();
  Future<void> insert(CartModel value);
  Future<void> deleteCart(int cartId);
}

class CartDB implements CartdbFunction {
  CartDB._internal();
  static CartDB instance = CartDB._internal();
  factory CartDB() {
    return instance;
  }

  Future<void> deleteCart(int cartId) async {
    final _cartdb = await Hive.openBox<CartModel>(CART_DB_NAME);
    _cartdb.delete(cartId);
    print("deleted");
  }

  // ValueNotifier<List<CategoryModel>> expenseCategoryListner = ValueNotifier([]);
  // ValueNotifier<List<CategoryModel>> incomeCategoryListner = ValueNotifier([]);
  @override
  Future<void> insert(CartModel value) async {
    final _categorydb = await Hive.openBox<CartModel>(CART_DB_NAME);
    _categorydb.put(value.id, value);
    //refreshUIEspenseAndIncome();
  }

  @override
  Future<List<CartModel>> getCart() async {
    final _categorydb = await Hive.openBox<CartModel>(CART_DB_NAME);
    return _categorydb.values.toList();
  }

  // Function to get a single cart item by ID
  Future<CartModel?> getCartItemById(int targetId) async {
    final _categorydb = await Hive.openBox<CartModel>(CART_DB_NAME);
    return _categorydb.get(targetId);
  }
}
