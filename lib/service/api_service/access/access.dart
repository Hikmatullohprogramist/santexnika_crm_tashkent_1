import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/access/access_mode.dart';
import 'package:santexnika_crm/service/api_service/wrap_response.dart';

import '../../../tools/dio_configration.dart';

class AccessService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Access 🟢 🟢 🔴 🔴

  Future<Either<String, List<AccessModel>>> getAccess() async {
    try {
      final response = BaseResponseApi().wrapResponse(
          await _dioConfig.get('access'),
          (data) =>
              (data as List).map((e) => AccessModel.fromJson(e)).toList());
      if (response.data.isEmpty) {
        return left(empty);
      } else {
        return right(response.data);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, String>> postAccess(
    String name,
  ) async {
    try {
      FormData formData = FormData.fromMap({'name': name});
      final response = await _dioConfig.post('access', data: formData);
      if (response.statusCode == 200) {
        return right(
          response.data['msg'],
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(postError);
    }
  }
}
