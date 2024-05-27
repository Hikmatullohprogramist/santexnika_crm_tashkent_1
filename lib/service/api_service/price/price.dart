import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/service/api_service/wrap_response.dart';

import '../../../models/price/priceModel.dart';
import '../../../tools/dio_configration.dart';

class PriceService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Price 🟢 🟢 🔴 🔴

  Future<Either<String, List<PriceModel>>> getPrice() async {
    try {
      final response = BaseResponseApi().wrapResponse(
        await _dioConfig.get('prices'),
        (data) => (data as List).map((e) => PriceModel.fromJson(e)).toList(),
      );
      if (response.data.isNotEmpty) {
        return right(response.data);
      } else {
        return left('xatolik');
      }
    } catch (e) {
      return left('xatolik');
    }
  }

  Future<Either<String, String>> postPrice(String name) async {
    try {
      FormData formData = FormData.fromMap({'name': name});
      final response = await _dioConfig.post('price', data: formData);
      if (response.statusCode == 201) {
        return right(response.data['msg']);
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<PriceModel>>> updatePrice(
    int id,
    String name,
    double value,
  ) async {
    try {
      final data = FormData.fromMap({
        'name': name,
        'value': value,
      });
      final response = await _dioConfig.post('price/$id', data: data);
      if (response.statusCode == 200) {
        return right(
          [
            PriceModel.fromJson(response.data),
          ],
        );
      } else {
        return left(
          response.data['message'],
        );
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
