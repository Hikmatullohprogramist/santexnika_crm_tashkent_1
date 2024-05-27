class SavedBasketModel {
  SavedBasketModel({
    required this.priceId,
    required this.price,
    required this.typeId,
    this.customerId,
  });
  late final int priceId;
  late final double price;
  late final int typeId;
  late final int? customerId;

  SavedBasketModel.fromJson(Map<String, dynamic> json) {
    priceId = json['price_id'];
    price = json['price'];
    typeId = json['type_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['price_id'] = priceId;
    _data['price'] = price;
    _data['type_id'] = typeId;
    _data['customer_id'] = customerId;
    return _data;
  }
}
