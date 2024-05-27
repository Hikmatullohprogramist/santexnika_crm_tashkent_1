
class ExpensesModel {
  ExpensesModel({
      this.id, 
      this.branchId, 
      this.priceId, 
      this.typeId, 
      this.userId, 
      this.cost, 
      this.comment, 
      this.createdAt, 
      this.updatedAt, 
      this.type, 
      this.price, 
      this.user, 
      this.branch,});

  ExpensesModel.fromJson(dynamic json) {
    id = json['id'];
    branchId = json['branch_id'];
    priceId = json['price_id'];
    typeId = json['type_id'];
    userId = json['user_id'];
    cost = json['cost'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
  }
  int? id;
  int? branchId;
  int? priceId;
  int? typeId;
  int? userId;
  String? cost;
  String? comment;
  String? createdAt;
  String? updatedAt;
  Type? type;
  Price? price;
  User? user;
  Branch? branch;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['branch_id'] = branchId;
    map['price_id'] = priceId;
    map['type_id'] = typeId;
    map['user_id'] = userId;
    map['cost'] = cost;
    map['comment'] = comment;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    if (price != null) {
      map['price'] = price?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (branch != null) {
      map['branch'] = branch?.toJson();
    }
    return map;
  }

}

class Branch {
  Branch({
      this.id, 
      this.name, 
      this.prefix, 
      this.barcode, 
      this.checkNumber, 
      this.createdAt, 
      this.updatedAt,});

  Branch.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    prefix = json['prefix'];
    barcode = json['barcode'];
    checkNumber = json['check_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  dynamic prefix;
  String? barcode;
  int? checkNumber;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['prefix'] = prefix;
    map['barcode'] = barcode;
    map['check_number'] = checkNumber;
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

class Price {
  Price({
      this.id, 
      this.name, 
      this.value, 
      this.createdAt, 
      this.updatedAt,});

  Price.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['value'] = value;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}

class Type {
  Type({
      this.id, 
      this.name, 
      this.createdAt, 
      this.updatedAt,});

  Type.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}