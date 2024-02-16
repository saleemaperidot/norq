import 'package:json_annotation/json_annotation.dart';

import 'rating.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  ItemModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return _$ItemModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}
