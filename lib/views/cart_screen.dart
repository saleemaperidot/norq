import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test/Models/cart/cart_model.dart';
import 'package:test/controller/cart_controller.dart';
import 'package:badges/badges.dart' as badges;

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());

    double total = cartController.calculateTotal();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                onPressed: () {
                  // Get.to(CartScreen());
                },
                icon: badges.Badge(
                    badgeContent: Obx(
                        () => Text(cartController.cartList.length.toString())),
                    child: Icon(Icons.shopping_cart)))
          ],
        ),
        body: SafeArea(
            child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return cartController.cartList.isEmpty
                          ? Container(
                              child: Center(
                                child: Text("No items in cart"),
                              ),
                            )
                          : Card(
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(cartController
                                            .cartList[index].image)),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          cartController.cartList[index].title,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          cartController.cartList[index].price
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: Colors.blue)),
                                      child:
                                          // Obx(() {
                                          //   // bool isInCart = cartController.cartList
                                          //   //     .any((cartItem) => cartItem.id == itemModel.id);
                                          //   // if (isInCart) {
                                          //   //   cartController.singleItemById(itemModel.id!);
                                          //   //   print("cart count in view ${_cartController.count}");
                                          //   // } else {}
                                          //return
                                          Obx(() {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (cartController
                                                        .cartList[index]
                                                        .count ==
                                                    0) {
                                                  Fluttertoast.showToast(
                                                      msg: "No item to delete",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                } else {
                                                  await cartController
                                                      .decrement(CartModel(
                                                          id: cartController
                                                              .cartList[index]
                                                              .id,
                                                          price: cartController
                                                              .cartList[index]
                                                              .price
                                                              .toString(),
                                                          count: cartController
                                                              .cartList[index]
                                                              .count,
                                                          description:
                                                              cartController
                                                                  .cartList[
                                                                      index]
                                                                  .description,
                                                          image: cartController
                                                              .cartList[index]
                                                              .image,
                                                          title: cartController
                                                              .cartList[index]
                                                              .title));
                                                  await cartController
                                                      .calculateTotal();
                                                  await cartController
                                                      .getCart();
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: Text("-"),
                                              ),
                                            ),
                                            Text(cartController
                                                .cartList[index].count
                                                .toString()),
                                            InkWell(
                                              onTap: () async {
                                                await cartController.Increament(
                                                    CartModel(
                                                        id: cartController
                                                            .cartList[index].id,
                                                        price: cartController
                                                            .cartList[index]
                                                            .price
                                                            .toString(),
                                                        count: cartController
                                                            .cartList[index]
                                                            .count,
                                                        description:
                                                            cartController
                                                                .cartList[index]
                                                                .description,
                                                        image: cartController
                                                            .cartList[index]
                                                            .image,
                                                        title: cartController
                                                            .cartList[index]
                                                            .title));
                                                await cartController
                                                    .calculateTotal();
                                                await cartController.getCart();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.green,
                                                child: Text("+"),
                                              ),
                                            ),
                                          ],
                                        );
                                      })),
                                  IconButton(
                                      onPressed: () async {
                                        await cartController.deleteFromCart(
                                            cartController.cartList[index].id);
                                        await cartController.getCart();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            );
                    });
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemCount: cartController.cartList.length),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(25),
                width: double.infinity,
                color: const Color.fromRGBO(3, 169, 244, 1),
                child: Obx(
                  () => Text(
                    "Total Price:${cartController.total}",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        )));
  }
}
