class ProductsAddModel {
  ProductsAddModel({
    this.productId,
    this.quantity,
  });

  ProductsAddModel.fromJson(dynamic json) {
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  int? productId;
  int? quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['quantity'] = quantity;
    return map;
  }
}
