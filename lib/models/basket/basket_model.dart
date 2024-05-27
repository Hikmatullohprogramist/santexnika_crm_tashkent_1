import 'package:santexnika_crm/models/pruduct/productModel.dart';

import 'basket_price.dart';

class BasketModel {
  int id;
  int storeId;
  int? orderId;
  int userId;
  String quantity;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<BasketPrice> basketPrice;
  ProductModel store;

  BasketModel({
    required this.id,
    required this.storeId,
    this.orderId,
    required this.userId,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.basketPrice,
    required this.store,
  });

  factory BasketModel.fromJson(Map<String, dynamic> json) {
    return BasketModel(
      id: json['id'],
      storeId: json['store_id'],
      orderId: json['order_id'],
      userId: json['user_id'],
      quantity: json['quantity'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      basketPrice: (json['basket_price'] as List)
          .map((basketPriceJson) => BasketPrice.fromJson(basketPriceJson))
          .toList(),
      store: ProductModel.fromJson(json['store']),
    );
  }
}

