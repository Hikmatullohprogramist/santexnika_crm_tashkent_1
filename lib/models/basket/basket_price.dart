import 'package:santexnika_crm/models/basket/basket_type_model.dart';

class BasketPrice {
  int id;
  int basketId;
  int priceId;
  String agreedPrice;
  String total;
  String priceCome;
  String priceSell;
  DateTime createdAt;
  DateTime updatedAt;
  PriceTypeModel priceType;

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
    required this.priceType,
  });

  factory BasketPrice.fromJson(Map<String, dynamic> json) {
    return BasketPrice(
      id: json['id'],
      basketId: json['basket_id'],
      priceId: json['price_id'],
      agreedPrice: json['agreed_price'],
      total: json['total'],
      priceCome: json['price_come'],
      priceSell: json['price_sell'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      priceType: PriceTypeModel.fromJson(json['price']),
    );
  }
}
