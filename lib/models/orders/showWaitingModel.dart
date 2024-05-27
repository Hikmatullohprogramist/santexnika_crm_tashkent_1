class ShowWaitingModel {
  ShowWaitingModel({
      this.basket, 
      this.calc,});

  ShowWaitingModel.fromJson(dynamic json) {
    if (json['basket'] != null) {
      basket = [];
      json['basket'].forEach((v) {
        basket?.add(Basket.fromJson(v));
      });
    }
    calc = json['calc'] != null ? Calc.fromJson(json['calc']) : null;
  }
  List<Basket>? basket;
  Calc? calc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (basket != null) {
      map['basket'] = basket?.map((v) => v.toJson()).toList();
    }
    if (calc != null) {
      map['calc'] = calc?.toJson();
    }
    return map;
  }

}

class Calc {
  Calc({
      this.uzs, 
      this.usd, 
      this.dollar,});

  Calc.fromJson(dynamic json) {
    uzs = json['uzs'];
    usd = json['usd'];
    dollar = json['dollar'];
  }
  int? uzs;
  double? usd;
  int? dollar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uzs'] = uzs;
    map['usd'] = usd;
    map['dollar'] = dollar;
    return map;
  }

}

class Basket {
  Basket({
      this.id, 
      this.storeId, 
      this.orderId, 
      this.userId, 
      this.quantity, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.basketPrice, 
      this.store,});

  Basket.fromJson(dynamic json) {
    id = json['id'];
    storeId = json['store_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['basket_price'] != null) {
      basketPrice = [];
      json['basket_price'].forEach((v) {
        basketPrice?.add(BasketPrice.fromJson(v));
      });
    }
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
  }
  int? id;
  int? storeId;
  int? orderId;
  int? userId;
  String? quantity;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<BasketPrice>? basketPrice;
  Store? store;

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
    if (basketPrice != null) {
      map['basket_price'] = basketPrice?.map((v) => v.toJson()).toList();
    }
    if (store != null) {
      map['store'] = store?.toJson();
    }
    return map;
  }

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

class BasketPrice {
  BasketPrice({
      this.id, 
      this.basketId, 
      this.priceId, 
      this.agreedPrice, 
      this.total, 
      this.priceCome, 
      this.priceSell, 
      this.createdAt, 
      this.updatedAt, 
      this.storeId, 
      this.price,});

  BasketPrice.fromJson(dynamic json) {
    id = json['id'];
    basketId = json['basket_id'];
    priceId = json['price_id'];
    agreedPrice = json['agreed_price'];
    total = json['total'];
    priceCome = json['price_come'];
    priceSell = json['price_sell'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storeId = json['store_id'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
  }
  int? id;
  int? basketId;
  int? priceId;
  String? agreedPrice;
  String? total;
  String? priceCome;
  String? priceSell;
  String? createdAt;
  String? updatedAt;
  int? storeId;
  Price? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['basket_id'] = basketId;
    map['price_id'] = priceId;
    map['agreed_price'] = agreedPrice;
    map['total'] = total;
    map['price_come'] = priceCome;
    map['price_sell'] = priceSell;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['store_id'] = storeId;
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