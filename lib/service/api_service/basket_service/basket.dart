// ignore_for_file: unused_field

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:santexnika_crm/models/basket/productsAddModel.dart';
import 'package:santexnika_crm/models/basket/save_basket_model.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';
import 'package:santexnika_crm/tools/handle_errors.dart';

import '../../../models/basket/basket.dart';

class BasketService {
  final Dio _dioConfig = DioConfig.getDio();

  Future<Either<String, OrderModel>> getBasket() async {
    try {
      final response = await _dioConfig.get('baskets');

      if (response.statusCode == 200) {
        return right(OrderModel.fromJson(response.data));
      } else {
        print(response.statusMessage);
        return left(response.statusMessage ?? "qandedur xatolik");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, OrderModel>> postBasket(
      List<ProductsAddModel> products) async {
    try {
      var data = json.encode({"products": products});
      final response = await _dioConfig.post('basket', data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(
          OrderModel.fromJson(response.data),
        );
      } else {
        print(response.statusMessage);
        print(response.data["error"]);
        return left(
          response.data != null && response.data["error"] != null
              ? response.data["error"]
              : response.statusMessage ?? "qandedur xatolik",
        );
      }
    } catch (e) {
      HandleError().handleError(e);
      return left(e.toString());
    }
  }

  Future<Either<String, OrderModel>> updateBasket(
      int productId, int priceId, double agreedPrice, double quantity) async {
    try {
      var data = FormData.fromMap({
        'product_id': productId,
        'price_id': priceId,
        'agreed_price': agreedPrice,
        'quantity': quantity
      });
      final response = await _dioConfig.post('basket/update', data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(
          OrderModel.fromJson(response.data),
        );
      } else {
        if (kDebugMode) {
          print(response.statusMessage);
        }
        return left(response.statusMessage ?? "qandedur xatolik");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, OrderModel>> deleteBasket(List<int> productId) async {
    try {
      var data = json.encode({"basket_ids": productId});
      final response = await _dioConfig.post('basket/delete', data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(
          OrderModel.fromJson(response.data),
        );
      } else {
        print(response.statusMessage);
        return left("qandedur xatolik");
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) {
        // Handle 404 error here
        // For example:
        // showErrorSnackbar("Page not found");
        return left("400");
      }
      return left(e.toString());
    }
  }

  Future<Either<String, dynamic>> saveBasket(List<SavedBasketModel> dataa,
      double? price, int? priceId, int? typeId, String? comment) async {
    try {
      var data = json.encode({
        "data": dataa,
        if (price != null) "price": price,
        if (priceId != null) "price_id": priceId,
        if (typeId != null) "type_id": typeId,
        if (comment != null) "comment": comment,
      });
      final response = await _dioConfig.post('basket/save', data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is OrderModel) {
          return right(OrderModel.fromJson(response.data));
        } else {
          if (response.data['status'] == true) {
            var checkId = response.data['order_id'];
            print(checkId);
            return right(checkId);
          }
          return left("Muvaffaqiyatli");
        }
      } else {
        return left("HTTP ${response.statusCode}");
        // Handle HTTP error if needed
      }
    } catch (e) {
      print(e);
      // Handle exception if needed
    }
    return left(
      "Failed to save basket",
    );
  }
}
