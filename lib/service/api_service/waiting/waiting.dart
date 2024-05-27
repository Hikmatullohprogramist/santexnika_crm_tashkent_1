import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/orders/waitingOrderModel.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

import '../../../models/orders/waitingModel.dart';

class WaitingOrderService {
  final Dio _dioConfig = DioConfig.getDio();

  Future<Either<String, List<WaitingOrderModel>>> getWaiting() async {
    try {
      final response = await _dioConfig.get('orders/waiting');

      if (response.statusCode == 200) {
        return right(
          (response.data as List)
              .map((e) => WaitingOrderModel.fromJson(e))
              .toList(),
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

  Future<Either<String, WaitingModelWithId>> getWaitingWithId(int id) async {
    try {
      final response = await _dioConfig.get('orders/waiting/$id');
      if (response.statusCode == 200) {
        return right(
          WaitingModelWithId.fromJson(response.data),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, String>> toWaiting(List basketIds) async {
    try {
      var data = json.encode({
        "basket_ids": basketIds,
      });
      final response = await _dioConfig.post('basket/waiting', data: data);
      if (response.statusCode == 200) {
        return right("Kutishga olindi");
      } else {
        return left(response.statusMessage ?? getError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, WaitingModelWithId>> unWaiting(int id) async {
    try {
      final response = await _dioConfig.get(
        'orders/unwaiting/$id',
      );
      if (response.statusCode == 200) {
        return right(
          WaitingModelWithId.fromJson(response.data),

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
