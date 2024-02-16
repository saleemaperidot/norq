import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:test/Models/cart/cart_model.dart';
import 'package:test/Models/item_model/item_model.dart';
import 'package:test/controller/cart_controller.dart';
import 'package:test/views/cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class SingleProduct extends StatelessWidget {
  SingleProduct({super.key, required this.itemModel});
  ItemModel itemModel;
  CartController cartController = Get.put(CartController());
  final CartController _cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    _cartController.singleItemById(itemModel.id!);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                _cartController.getCart();
                Get.to(CartScreen());
              },
              icon: badges.Badge(
                  badgeContent: Obx(
                      () => Text(cartController.cartList.length.toString())),
                  child: Icon(Icons.shopping_cart)))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // padding: EdgeInsets.all(10),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image(image: NetworkImage(itemModel.image!)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    itemModel.title!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$${itemModel.price!.toString()}",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(itemModel.description!),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue)),
                    child: Obx(() {
                      bool isInCart = _cartController.cartList
                          .any((cartItem) => cartItem.id == itemModel.id);
                      if (isInCart) {
                        _cartController.singleItemById(itemModel.id!);
                        print("cart count in view ${_cartController.count}");
                      } else {}
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_cartController.count.value == 0) {
                                Fluttertoast.showToast(
                                    msg: "No item to delete",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                _cartController.decrement(CartModel(
                                    id: itemModel.id!,
                                    price: itemModel.price!.toString(),
                                    count: _cartController.count.value,
                                    description: itemModel.description!,
                                    image: itemModel.image!,
                                    title: itemModel.title!));
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text("-"),
                            ),
                          ),
                          isInCart
                              ? Text(_cartController.count.toString())
                              : Text("0"),
                          InkWell(
                            onTap: () async {
                              _cartController.Increament(CartModel(
                                  id: itemModel.id!,
                                  price: itemModel.price!.toString(),
                                  count: _cartController.count.value,
                                  description: itemModel.description!,
                                  image: itemModel.image!,
                                  title: itemModel.title!));
                              await cartController.getCart();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text("+"),
                            ),
                          ),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
