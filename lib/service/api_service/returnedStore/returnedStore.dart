import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/orders/transfer2storeModel.dart';
import 'package:santexnika_crm/models/retruned_store/returnedStoreModel.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

import '../../../models/base_model.dart';
import '../wrap_response.dart';

class ReturnedStoreService {
  final Dio _dioConfig = DioConfig.getDio();

  ///Product 🟢 🔴 🔴 🔴

  Future<Either<String, BaseModel<List<ReturnedStoreModel>>>> getReturned(
      int page, String query) async {
    try {
      // final response = await _dioConfig.get(
      //   "returned",
      //   queryParameters: {"query": query, "page": page},
      // );

      final response = await _dioConfig.request("returned",
          options: Options(
            method: "GET",
          ));
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ReturnedStoreModel.fromJson(e),
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

  Future<Either<String, ReturnedStoreModel>> postReturned(
      List<Transfer2StoreModel> returedModel, int priceId, int typeId) async {
    try {
      var data = json.encode(
        {"data": returedModel, "price_id": priceId, "type_id": typeId},
      );
      final response = await _dioConfig.post('return', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(ReturnedStoreModel.fromJson(response.data));
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, BaseModel<List<ReturnedStoreModel>>>>
      searchReturnedOnes(String query) async {
    try {
      final response = await _dioConfig.get('returned?search=$query');
      // final respionse = BaseResponseApi().wrapResponse(
      //     await _dioConfig.get('products?page=$page'), (data) => (data) {});
      if (response.statusCode == 200) {
        return right(BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map((e) => ReturnedStoreModel.fromJson(e))
                .toList()));
      } else {
        return left(response.statusMessage ?? getError);
      }
    } catch (e) {
      return left(getError + e.toString());
    }
  }
}
