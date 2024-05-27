import 'package:santexnika_crm/models/customer/customerModel.dart';

class WaitingOrderModel {
  WaitingOrderModel({
      this.id, 
      this.userId, 
      this.branchId, 
      this.customerId, 
      this.checkId, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.customer, 
      this.user,});

  WaitingOrderModel.fromJson(dynamic json) {
    id = json['id']??0;
    userId = json['user_id']??0;
    branchId = json['branch_id']??0;
    customerId = json['customer_id']??0;
    checkId = json['check_id']??0;
    status = json['status']??0;
    createdAt = json['created_at']??0;
    updatedAt = json['updated_at']??0;
    customer = json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id??0;
    map['user_id'] = userId??0;
    map['branch_id'] = branchId??0;
    map['customer_id'] = customerId??0;
    map['check_id'] = checkId??0;
    map['status'] = status??0;
    map['created_at'] = createdAt??0;
    map['updated_at'] = updatedAt??0;
    map['customer'] = customer??0;
    if (user != null) {
      map['user'] = user?.toJson();
    }else{
      [];
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.name, 
      this.phone, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.branchId,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchId = json['branch_id'];
  }
  int? id;
  String? name;
  String? phone;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? branchId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['branch_id'] = branchId;
    return map;
  }

}