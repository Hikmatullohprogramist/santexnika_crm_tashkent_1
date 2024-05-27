 import 'package:santexnika_crm/models/statistic/customer.dart';

import '../pruduct/productModel.dart';
import '../user/usersModel.dart';

class SelledProducts {
  int id;
  int storeId;
  int orderId;
  int userId;
  double quantity;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  ProductModel? store;
  OrderDetails? order;
  Customer? customer;
  UsersModel? user;
  List<BasketPrice> basketPrices;

  SelledProducts({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.userId,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.store,
    this.order,
    this.customer,
    this.user,
    required this.basketPrices,
  });

  factory SelledProducts.fromJson(Map<String, dynamic> json) {
    return SelledProducts(
      id: json['id'],
      storeId: json['store_id'],
      orderId: json['order_id'],
      userId: json['user_id'],
      quantity: double.parse(json['quantity']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      store:
          json['store'] != null ? ProductModel.fromJson(json['store']) : null,
      order:
          json['order'] != null ? OrderDetails.fromJson(json['order']) : null,
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      user: json['user'] != null ? UsersModel.fromJson(json['user']) : null,
      basketPrices: (json['basket_price'] as List)
          .map((basketPriceJson) => BasketPrice.fromJson(basketPriceJson))
          .toList(),
    );
  }
}

class OrderDetails {
  final int id;
  final int userId;
  final int branchId;
  final int? customerId;
  final int? checkId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? dollar;

  OrderDetails({
    required this.id,
    required this.userId,
    required this.branchId,
    this.customerId,
    this.checkId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.dollar,
   });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {

    return OrderDetails(
      id: json['id'],
      userId: json['user_id'],
      branchId: json['branch_id'],
      customerId: json['customer_id'],
      checkId: json['check_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      dollar: json['dollar'] ?? "",

    );
  }
}


class BasketPrice {
  final int id;
  final int basketId;
  final int priceId;
  final double agreedPrice;
  final double total;
  final double priceCome;
  final double priceSell;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int storeId;

  BasketPrice({
    required this.id,
    required this.basketId,
    required this.priceId,
    required this.agreedPrice,
    required this.total,
    required this.priceCome,
    required this.priceSell,
    required this.createdAt,
    required this.updatedAt,
    required this.storeId,
  });

  factory BasketPrice.fromJson(Map<String, dynamic> json) {
    return BasketPrice(
      id: json['id'],
      basketId: json['basket_id'],
      priceId: json['price_id'],
      agreedPrice: double.parse(json['agreed_price']),
      total: double.parse(json['total']),
      priceCome: double.parse(json['price_come']),
      priceSell: double.parse(json['price_sell']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      storeId: json['store_id'],
    );
  }
}
