
class ReturnedStoreModel {
  ReturnedStoreModel({
      this.id, 
      this.storeId, 
      this.userId, 
      this.branchId, 
      this.quantity, 
      this.comment, 
      this.createdAt, 
      this.updatedAt, 
      this.cost,
      this.user,
      this.store,});

  ReturnedStoreModel.fromJson(dynamic json) {
    id = json['id'];
    storeId = json['store_id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    quantity = json['quantity'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cost = json['cost'];

    user = json['user'] != null ? User.fromJson(json['user']) : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
  }
  int? id;
  int? storeId;
  int? userId;
  int? branchId;
  String? quantity;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? cost;
  User? user;
  Store? store;


}

class Store {
  Store({
      this.id, 
      this.categoryId, 
      this.branchId, 
      this.priceId, 
      this.name, 
      this.madeIn, 
      this.barcode, 
      this.priceCome, 
      this.priceSell, 
      this.priceWholesale, 
      this.quantity, 
      this.dangerCount, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  Store.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    branchId = json['branch_id'];
    priceId = json['price_id'];
    name = json['name'];
    madeIn = json['made_in'];
    barcode = json['barcode'];
    priceCome = json['price_come'];
    priceSell = json['price_sell'];
    priceWholesale = json['price_wholesale'];
    quantity = json['quantity'];
    dangerCount = json['danger_count'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? categoryId;
  int? branchId;
  int? priceId;
  String? name;
  String? madeIn;
  String? barcode;
  String? priceCome;
  String? priceSell;
  String? priceWholesale;
  String? quantity;
  String? dangerCount;
  int? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['branch_id'] = branchId;
    map['price_id'] = priceId;
    map['name'] = name;
    map['made_in'] = madeIn;
    map['barcode'] = barcode;
    map['price_come'] = priceCome;
    map['price_sell'] = priceSell;
    map['price_wholesale'] = priceWholesale;
    map['quantity'] = quantity;
    map['danger_count'] = dangerCount;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
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