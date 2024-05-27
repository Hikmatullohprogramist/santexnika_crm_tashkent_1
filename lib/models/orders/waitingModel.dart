class WaitingModelWithId {
  WaitingModelWithId({
    required this.data,
    required this.total,
  });
  late final Data data;
  late final Total total;

  WaitingModelWithId.fromJson(Map<String, dynamic> json){
    data = Data.fromJson(json['data']);
    total = Total.fromJson(json['total']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['total'] = total.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.branchId,
    this.customerId,
    this.checkId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
    required this.user,
    required this.baskets,
  });
  late final int id;
  late final int userId;
  late final int branchId;
  late final Null customerId;
  late final Null checkId;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final Null customer;
  late final User user;
  late final List<Baskets> baskets;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    customerId = null;
    checkId = null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = null;
    user = User.fromJson(json['user']);
    baskets = List.from(json['baskets']).map((e)=>Baskets.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['branch_id'] = branchId;
    _data['customer_id'] = customerId;
    _data['check_id'] = checkId;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['customer'] = customer;
    _data['user'] = user.toJson();
    _data['baskets'] = baskets.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.branchId,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final int branchId;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['branch_id'] = branchId;
    return _data;
  }
}

class Baskets {
  Baskets({
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
  late final int id;
  late final int storeId;
  late final int orderId;
  late final int userId;
  late final String quantity;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final Store store;
  late final List<BasketPrice> basketPrice;

  Baskets.fromJson(Map<String, dynamic> json){
    id = json['id'];
    storeId = json['store_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    store = Store.fromJson(json['store']);
    basketPrice = List.from(json['basket_price']).map((e)=>BasketPrice.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['store_id'] = storeId;
    _data['order_id'] = orderId;
    _data['user_id'] = userId;
    _data['quantity'] = quantity;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['store'] = store.toJson();
    _data['basket_price'] = basketPrice.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Store {
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
  late final int id;
  late final int categoryId;
  late final int branchId;
  late final int priceId;
  late final String name;
  late final String madeIn;
  late final String barcode;
  late final String priceCome;
  late final String priceSell;
  late final String priceWholesale;
  late final String quantity;
  late final String dangerCount;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final Category category;

  Store.fromJson(Map<String, dynamic> json){
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
    category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['category_id'] = categoryId;
    _data['branch_id'] = branchId;
    _data['price_id'] = priceId;
    _data['name'] = name;
    _data['made_in'] = madeIn;
    _data['barcode'] = barcode;
    _data['price_come'] = priceCome;
    _data['price_sell'] = priceSell;
    _data['price_wholesale'] = priceWholesale;
    _data['quantity'] = quantity;
    _data['danger_count'] = dangerCount;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['category'] = category.toJson();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.branchId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int branchId;
  late final String name;
  late final String createdAt;
  late final String updatedAt;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    branchId = json['branch_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['branch_id'] = branchId;
    _data['name'] = name;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class BasketPrice {
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
  late final int id;
  late final int basketId;
  late final int priceId;
  late final String agreedPrice;
  late final String total;
  late final String priceCome;
  late final String priceSell;
  late final String createdAt;
  late final String updatedAt;
  late final int storeId;

  BasketPrice.fromJson(Map<String, dynamic> json){
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
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['basket_id'] = basketId;
    _data['price_id'] = priceId;
    _data['agreed_price'] = agreedPrice;
    _data['total'] = total;
    _data['price_come'] = priceCome;
    _data['price_sell'] = priceSell;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['store_id'] = storeId;
    return _data;
  }
}

class Total {
  Total({
    required this.dollar,
    required this.sum,
  });
  late final int dollar;
  late final int sum;

  Total.fromJson(Map<String, dynamic> json){
    dollar = json['dollar'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dollar'] = dollar;
    _data['sum'] = sum;
    return _data;
  }
}