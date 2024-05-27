import 'package:dio/dio.dart';
import 'package:santexnika_crm/models/base_model.dart';

class BaseResponseApi {
  BaseModel<T> wrapResponse<T>(
      Response<dynamic> response, T Function(dynamic) converter) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return BaseModel.fromJson(response.data, converter);
    } else {
      return BaseModel<T>(
        currentPage: 0,
        data: converter({}),
        firstPageUrl: "",
        from: 0,
        lastPage: 0,
        lastPageUrl: "",
        links: [],
        path: "",
        perPage: 0,
        to: 0,
        total: 0,
      );
    }
  }
}
