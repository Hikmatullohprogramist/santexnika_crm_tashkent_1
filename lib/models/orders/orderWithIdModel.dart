// order_model.dart

import '../user/usersModel.dart';

class OrderWithIdModel {
  Data? data;
  Total? total;

  OrderWithIdModel({this.data, this.total});

  OrderWithIdModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
  }
}

class Data {
  final int? id;
  final int? userId;
  final int? branchId;
  final int? customerId;
  final int? checkId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final UsersModel? user;
  final List<Basket>? baskets;
  final List<OrderPrice>? orderPrices;

  Data({
    required this.id,
    this.userId,
    this.branchId,
    this.customerId,
    this.checkId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.baskets,
    this.orderPrices,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      branchId: json['branch_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      checkId: json['check_id'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      user: json['user'] != null ? UsersModel.fromJson(json['user']) : null,
      baskets: json['baskets'] != null
          ? List<Basket>.from(json['baskets'].map((x) => Basket.fromJson(x)))
          : null,      orderPrices: json['order_price'] != null
          ? List<OrderPrice>.from(json['order_price'].map((x) => OrderPrice.fromJson(x)))
          : null,
    );
  }
}
class OrderPrice {
  final int id;
  final int orderId;
  final int priceId;
  final int typeId;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderPrice({
    required this.id,
    required this.orderId,
    required this.priceId,
    required this.typeId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an OrderPrice object from JSON
  factory OrderPrice.fromJson(Map<String, dynamic> json) {
    return OrderPrice(
      id: json['id'],
      orderId: json['order_id'],
      priceId: json['price_id'],
      typeId: json['type_id'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert an OrderPrice object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'price_id': priceId,
      'type_id': typeId,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Define the Basket model
class Basket {
  final int id;
  final int storeId;
  final int orderId;
  final int userId;
  final String quantity;
  final int status;
  final String createdAt;
  final String updatedAt;
  final Store store;
  final List<BasketItem> basketPrice;

  Basket({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.userId,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.store,
    required this.basketPrice,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['id'],
      storeId: json['store_id'],
      orderId: json['order_id'],
      userId: json['user_id'],
      quantity: json['quantity'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      store: Store.fromJson(json['store']),
      basketPrice: List<BasketItem>.from(
          json['basket_price'].map((x) => BasketItem.fromJson(x))),
    );
  }
}

// Define the Store model
class Store {
  final int id;
  final int categoryId;
  final int branchId;
  final int priceId;
  final String name;
  final String madeIn;
  final String barcode;
  final String priceCome;
  final String priceSell;
  final String? priceWholesale;
  final String quantity;
  final String dangerCount;
  final int status;
  final String createdAt;
  final String updatedAt;
  final Category category;

  Store({
    required this.id,
    required this.categoryId,
    required this.branchId,
    required this.priceId,
    required this.name,
    required this.madeIn,
    required this.barcode,
    required this.priceCome,
    required this.priceSell,
    required this.priceWholesale,
    required this.quantity,
    required this.dangerCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      categoryId: json['category_id'],
      branchId: json['branch_id'],
      priceId: json['price_id'],
      name: json['name'],
      madeIn: json['made_in'],
      barcode: json['barcode'],
      priceCome: json['price_come'],
      priceSell: json['price_sell'],
      priceWholesale: json['price_wholesale'] ?? "0",
      quantity: json['quantity'],
      dangerCount: json['danger_count'],
      status: json['status'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      category: Category.fromJson(json['category']),
    );
  }
}

// Define the Category model
class Category {
  final int id;
  final int branchId;
  final String name;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.branchId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      branchId: json['branch_id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class BasketItem {
  final int id;
  final int basketId;
  final int priceId;
  final String agreedPrice;
  final String total;
  final String priceCome;
  final String priceSell;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int storeId;

  BasketItem({
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

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      id: json['id'],
      basketId: json['basket_id'],
      priceId: json['price_id'],
      agreedPrice: json['agreed_price'],
      total: json['total'],
      priceCome: json['price_come'],
      priceSell: json['price_sell'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      storeId: json['store_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'basket_id': basketId,
      'price_id': priceId,
      'agreed_price': agreedPrice,
      'total': total,
      'price_come': priceCome,
      'price_sell': priceSell,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'store_id': storeId,
    };
  }
}

class Total {
  dynamic dollar;
  dynamic sum;
  dynamic reduce_price;
  dynamic reduced_price_type;

  Total({this.dollar, this.sum});

  Total.fromJson(Map<String, dynamic> json) {
    dollar = json['dollar'];
    sum = json['sum'];
    reduce_price = json['reduced_price'];
    reduced_price_type = json['reduced_price_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dollar'] = this.dollar;
    data['sum'] = this.sum;
    data['reduced_price_type'] = this.reduced_price_type;
    return data;
  }
}
