import 'basket_model.dart';
import 'calc_model.dart';

class OrderModel {
  OrderModel({
    required this.basket,
    required this.calc,
  });

  late final List<BasketModel> basket;
  late final Calc calc;

  OrderModel.fromJson(Map<String, dynamic> json) {
    basket =
        List.from(json['basket']).map((e) => BasketModel.fromJson(e)).toList();
    calc = Calc.fromJson(json['calc']);
  }
}
