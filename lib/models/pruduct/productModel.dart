class ProductModel {
  ProductModel({
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
    this.updatedAt,
    this.media,
    this.category,
    this.branch,
    this.price,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
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
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media?.add(v);
      });
    }
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
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
  dynamic priceWholesale;
  String? quantity;
  String? dangerCount;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? media;
  Category? category;
  Branch? branch;
  Price? price;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
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
    if (media != null) {
      map['media'] = media?.map((dynamic v) => v).toList();
    }
    if (category != null) {
      map['category'] = category?.toJson();
    }
    if (branch != null) {
      map['branch'] = branch?.toJson();
    }
    if (price != null) {
      map['price'] = price?.toJson();
    }
    return map;
  }
}

class Price {
  Price({
    this.id,
    this.name,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  Price.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['value'] = value;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
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
    this.updatedAt,
  });

  Branch.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> map = <String, dynamic>{};
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

class Category {
  Category({
    this.id,
    this.branchId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  int? branchId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['branch_id'] = branchId;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
