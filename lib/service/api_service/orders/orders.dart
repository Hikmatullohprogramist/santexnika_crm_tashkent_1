// ignore_for_file: deprecated_member_use

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/orders/ordersModel.dart';

import '../../../models/orders/orderWithIdModel.dart';
import '../../../models/orders/selled_products.dart';
import '../../../tools/dio_configration.dart';

class OrdersService {
  final Dio _dioConfig = DioConfig.getDio();

  Future<Either<String, BaseModel<List<OrdersModel>>>> getOrders(
      int page, String query) async {
    try {
      final response = await _dioConfig.get("orders?page=$page&search=$query");
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => OrdersModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, OrderWithIdModel>> getOrdersWithId(
    int page,
    int id,
  ) async {
    try {
      final response = await _dioConfig.get("order/$id?page=$page");
      if (response.statusCode == 200) {
        return right(
          OrderWithIdModel.fromJson(response.data),
        );
      } else if (response.statusCode == 404) {
        return left('Bu yerdagi hamma narsa qaytarilgan');
      } else {
        return left(getError);
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 404) {
        return left('Bu yerdagi hamma narsa qaytarilgan');
      } else {
        return left('Error: ${e.toString()}');
      }
    }
  }

  Future<Either<String, BaseModel<List<OrdersModel>>>> searchSold(
      String query) async {
    try {
      final response = await _dioConfig.get('orders?search=$query');
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => OrdersModel.fromJson(e)).toList(),
          ),
        );
      } else {
        return left(response.statusMessage ?? getError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, BaseModel<List<SelledProducts>>>> getSelledProducts(
      String query, int page) async {
    try {
      String url = "orders/selled?page=$page";
      if (query.isNotEmpty) {
        url += "&search=$query";
      }

      print(url);
      final response = await _dioConfig.get(url);
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => SelledProducts.fromJson(e)).toList(),
          ),
        );
      } else {
        return left(response.statusMessage ?? getError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
