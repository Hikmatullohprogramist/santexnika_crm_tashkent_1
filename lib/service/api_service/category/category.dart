import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

import '../../../models/categories/CategoryModel.dart';

class CategoryService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Category 🟢 🟢 🔴 🔴

  Future<Either<String, BaseModel<List<CategoryModel>>>> getCategory(
      int page) async {
    try {
      final response = await _dioConfig.get('categories?page=$page');

      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => CategoryModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left('Xatolik');
      }
    } catch (e) {
      return left('xatolik $e');
    }
  }

  Future<Either<String, String>> postCategory(
    String name,
    String branchId,
  ) async {
    try {
      FormData formData = FormData.fromMap(
        {'name': name, 'branch_id': branchId},
      );
      final response = await _dioConfig.post(
        'category',
        data: formData,
      );
      if (response.statusCode == 201) {
        return right(response.data['message']);
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(postError);
    }
  }



  Future<Either<String, String>> updateCategory(
      String name, String branchId, int categoryId) async {
    try {
      FormData formData = FormData.fromMap(
        {'name': name, 'branch_id': branchId},
      );
      final response = await _dioConfig.post(
        'category/$categoryId/update',
        data: formData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return right("Muvaffaqiyatli o'zgartirildi !");
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(postError);
    }
  }

  Future<Either<String, BaseModel<List<CategoryModel>>>> deleteCategory(
      int id) async {
    try {
      final response = await _dioConfig.delete('category/$id');
      if (response.statusCode == 200) {
        if (response.data['message'] == "Category has products") {
          return left("Muvaffaqiyatsizlik");
        } else {
          return right(
            BaseModel.fromJson(
              response.data,
              (data) => (data as List)
                  .map(
                    (e) => CategoryModel.fromJson(e),
                  )
                  .toList(),
            ),
          );
        }
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
