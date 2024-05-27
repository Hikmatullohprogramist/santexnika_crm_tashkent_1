import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/taypes/taypes_model.dart';
import 'package:santexnika_crm/service/api_service/wrap_response.dart';

import '../../../tools/dio_configration.dart';

class TypesService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Types 🟢 🟢 🔴 🔴

  Future<Either<String, List<TypesModel>>> getTypes() async {
    try {
      final response = BaseResponseApi().wrapResponse(
          await _dioConfig.get('types'),
          (data) => (data as List).map((e) => TypesModel.fromJson(e)).toList());
      if (response.data.isNotEmpty) {
        return right(response.data);
      } else {
        return left('left');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<TypesModel>>> postTypes(
    String name,
  ) async {
    try {
      FormData formData = FormData.fromMap({'name': name});
      final response = BaseResponseApi().wrapResponse(
        await _dioConfig.post('type', data: formData),
        (data) => (data as List).map((e) => TypesModel.fromJson(e)).toList(),
      );
      if (response.data.isNotEmpty) {
        return right(response.data);
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, List<TypesModel>>> updateTypes(
    int id,
    String name,
  ) async {
    FormData formData = FormData.fromMap({'name': name});

    try {
      final response = await _dioConfig.post('type/$id', data: formData);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return right(
          [
            TypesModel.fromJson(response.data),
          ],
        );
      } else {
        return left(
          response.data['message'],
        );
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
