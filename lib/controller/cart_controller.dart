import 'package:get/get.dart';
import 'package:test/Models/cart/cart_model.dart';
import 'package:test/db_functions/cart_db.dart';

class CartController extends GetxController {
  RxList<CartModel> cartList = <CartModel>[].obs;
  RxInt count = 0.obs;
  RxDouble total = 0.0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> singleItemById(int id) async {
    CartModel? cartModel = await CartDB.instance.getCartItemById(id);

    print("Single item by id ${cartModel!.count}");

    if (cartList.isEmpty) {
      print("No item");
    } else {
      count.value = cartModel.count;
      print("In single item${count.value}");
    }
  }

  Future<void> decrement(CartModel cart) async {
    // Loading cart items
    List<CartModel> _cartList = await CartDB.instance.getCart();
    print("Increment");
    print(_cartList);

    // Check if the item is already in the cart
    print("Increment(cart) called");
    var existingItem =
        _cartList.firstWhereOrNull((cartItem) => cartItem.id == cart.id);
    print("Existing Item: $existingItem");

    if (existingItem != null) {
      // Use indexWhere with custom comparison function
      int index =
          _cartList.indexWhere((cartItem) => cartItem.id == existingItem.id);
      print("Index: $index");

      if (index != -1) {
        // Increment the count if the item is already in the cart
        // _cartList[index] =
        //     existingItem.incrementCount(_cartList[index].count + 1);
        // print("Updated Cart Item: ${_cartList[index]}");

        // Assign the modified object back to the same key in the Hive box
        await CartDB.instance.insert(CartModel(
            id: _cartList[index].id,
            price: _cartList[index].price,
            count: _cartList[index].count - 1,
            description: _cartList[index].description,
            image: _cartList[index].image,
            title: _cartList[index].title));

        // To get count
        await singleItemById(cart.id);
        print("Count Increment: ${_cartList[index].count}");
        calculateTotal();
      } else {
        print("Item not found in the cart list.");
      }
    } else {}
  }

  Future<void> deleteFromCart(int id) async {
    await CartDB.instance.deleteCart(id);
    print("deleted");
    cartList.clear();
    List<CartModel> _cartList = await CartDB.instance.getCart();

    cartList.addAll(_cartList);
    calculateTotal();
  }

  Future<void> Increament(CartModel cart) async {
    // Loading cart items
    List<CartModel> _cartList = await CartDB.instance.getCart();
    print("Increment");
    print(_cartList);

    // Check if the item is already in the cart
    print("Increment(cart) called");
    var existingItem =
        _cartList.firstWhereOrNull((cartItem) => cartItem.id == cart.id);
    print("Existing Item: $existingItem");

    if (existingItem != null) {
      // Use indexWhere with custom comparison function
      int index =
          _cartList.indexWhere((cartItem) => cartItem.id == existingItem.id);
      print("Index: $index");

      if (index != -1) {
        // Increment the count if the item is already in the cart
        // _cartList[index] =
        //     existingItem.incrementCount(_cartList[index].count + 1);
        // print("Updated Cart Item: ${_cartList[index]}");

        // Assign the modified object back to the same key in the Hive box
        await CartDB.instance.insert(CartModel(
            id: _cartList[index].id,
            price: _cartList[index].price,
            count: _cartList[index].count + 1,
            description: _cartList[index].description,
            image: _cartList[index].image,
            title: _cartList[index].title));

        // To get count
        await singleItemById(cart.id);
        print("Count Increment: ${_cartList[index].count}");
        calculateTotal();
      } else {
        print("Item not found in the cart list.");
      }
    } else {
      // Add the item to the cart with count = 1 if it's not in the cart
      addToCart(cart);
    }
  }

// Inside your CartController or wherever you manage the cart
  double calculateTotal() {
    double _total = 0.0;

    for (var item in cartList) {
      // Assuming price is a String, you might need to convert it to a numeric type
      double price = double.parse(item.price);
      _total += price * item.count;
    }
    total.value = _total;

    return _total;
  }

  Future<void> getCart() async {
    cartList.clear();
    List<CartModel> _cartList = await CartDB.instance.getCart();

    cartList.addAll(_cartList);
    print(cartList);
  }

  Future<void> addToCart(CartModel cart) async {
    await CartDB.instance.insert(CartModel(
        id: cart.id,
        price: cart.price,
        count: 1,
        description: cart.description,
        image: cart.image,
        title: cart.title));
    getCart();
  }
}
