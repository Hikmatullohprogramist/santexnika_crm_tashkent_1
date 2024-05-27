import 'package:santexnika_crm/models/customer/customerModel.dart';

import '../statistic/user.dart';

class OrdersModel {
  OrdersModel({
    this.id,
    this.userId,
    this.branchId,
    this.customerId,
    this.checkId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.baskets,
  });

  OrdersModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    customerId = json['customer_id'];
    checkId = json['check_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['customer'] != null) {
      customer = CustomerModel.fromJson(json["customer"]);
    }
    if (json['baskets'] != null) {
      baskets = [];
      json['baskets'].forEach((v) {
        baskets?.add(Baskets.fromJson(v));
      });
    } else {
      [];
    }
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    } else {
      [];
    }
  }

  int? id;
  int? userId;
  int? branchId;
  dynamic customerId;
  dynamic checkId;
  int? status;
  String? createdAt;
  String? updatedAt;
  CustomerModel? customer;
  List<Baskets>? baskets;
  User? user;
}

class Baskets {
  Baskets({
    this.id,
    this.storeId,
    this.orderId,
    this.userId,
    this.quantity,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Baskets.fromJson(dynamic json) {
    id = json['id'];
    storeId = json['store_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  int? storeId;
  int? orderId;
  int? userId;
  String? quantity;
  int? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['store_id'] = storeId;
    map['order_id'] = orderId;
    map['user_id'] = userId;
    map['quantity'] = quantity;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
