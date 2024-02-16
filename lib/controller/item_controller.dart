import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:test/Models/item_model/item_model.dart';

class ItemController extends GetxController {
  RxList<ItemModel> itemsList = <ItemModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    items();
    super.onInit();
  }

  void items() async {
    itemsList.clear();
    isLoading.value = true;
    try {
      final response =
          await Dio(BaseOptions()).get("https://fakestoreapi.com/products");
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        List<ItemModel> _itemList = List.from(response.data)
            .map((item) => ItemModel.fromJson(item))
            .toList();
        // itemsList.value.addAll(_itemList);
        itemsList.addAll(_itemList);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print(e);
    }
  }
}
