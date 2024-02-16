import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/Models/cart/cart_model.dart';
import 'package:test/Models/item_model/item_model.dart';
import 'package:test/controller/cart_controller.dart';
import 'package:test/controller/item_controller.dart';
import 'package:test/views/cart_screen.dart';
import 'package:test/views/single_product.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  ItemController itemController = Get.put(ItemController());

  CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    cartController.getCart();
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("ITEMS"),
        actions: [
          IconButton(
              onPressed: () {
                cartController.getCart();
                Get.to(CartScreen());
              },
              icon: badges.Badge(
                  badgeContent: Obx(
                      () => Text(cartController.cartList.length.toString())),
                  child: Icon(Icons.shopping_cart)))
        ],
      ),
      body: SafeArea(child: Obx(() {
        return itemController.itemsList.isEmpty
            ? SizedBox()
            : GridView.count(
                childAspectRatio: 1,
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                children:
                    List.generate(itemController.itemsList.length, (index) {
                  return Stack(children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => SingleProduct(
                              itemModel: ItemModel(
                                category:
                                    itemController.itemsList[index].category,
                                description:
                                    itemController.itemsList[index].description,
                                id: itemController.itemsList[index].id,
                                image: itemController.itemsList[index].image,
                                price: itemController.itemsList[index].price,
                                rating: itemController.itemsList[index].rating,
                                title: itemController.itemsList[index].title,
                              ),
                            ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      fit: BoxFit.fill,
                                      image: NetworkImage(itemController
                                          .itemsList[index].image!)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    itemController.itemsList[index]
                                        .title!, // Add your content here
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    '\$${itemController.itemsList[index].price}', // Add your content here
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Positioned(
                        bottom: 1,
                        right: 5,
                        child: Obx(() {
                          bool isInCart = cartController.cartList.any(
                              (cartItem) =>
                                  cartItem.id ==
                                  itemController.itemsList[index].id);
                          print(isInCart);
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(30, 10),
                                elevation: 100,
                                backgroundColor: Colors.blue,
                                side: BorderSide(color: Colors.white)),
                            child: Text(
                              isInCart ? "Go to Cart" : "Add to Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (isInCart) {
                                // Item is in cart, navigate to the cart screen or perform other actions
                                // Navigate to the cart screen using Get.to()
                                Get.to(() => CartScreen());
                              } else {
                                // Item is not in cart, add it to the cart
                                // cartController
                                //     .addToCart(itemController.itemsList[index]);

                                cartController.addToCart(CartModel(
                                    id: itemController.itemsList[index].id!,
                                    price: itemController
                                        .itemsList[index].price!
                                        .toString(),
                                    count: 1,
                                    description: itemController
                                        .itemsList[index].description!,
                                    image:
                                        itemController.itemsList[index].image!,
                                    title: itemController
                                        .itemsList[index].title!));
                              }
                            },
                          );
                        }))
                  ]);
                }),
              );
      })),
    );
  }
}
