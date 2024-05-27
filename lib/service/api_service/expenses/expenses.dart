import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/expenses/expenses.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

class ExpensesSerice {
  final Dio _dioConfig = DioConfig.getDio();

  /// Expenses 🟢 🟢 🔴 🔴

  Future<Either<String, BaseModel<List<ExpensesModel>>>> getExpenses(
      int page, String query) async {
    try {
      final response =
          await _dioConfig.get('expenses?page=$page&search=$query');
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ExpensesModel.fromJson(e),
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

  Future<Either<String, BaseModel<List<ExpensesModel>>>> postExpenses(
    String name,
    String comment,
    int typeId,
    int priceId,
    String cost,
  ) async {
    try {
      var formData = FormData.fromMap({
        'name': name,
        'comment': comment,
        'type_id': typeId,
        'price_id': priceId,
        'cost': cost,
        'status': 1
      });
      final response = await _dioConfig.post('expense', data: formData);

      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => ExpensesModel.fromJson(e)).toList(),
          ),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<ExpensesModel>>>> updateExpenses(
    int id,
    String name,
    String comment,
    int typeId,
    int priceId,
    String cost,
  ) async {
    try {
      var formData = FormData.fromMap({
        'name': name,
        'comment': comment,
        'type_id': typeId,
        'price_id': priceId,
        'cost': cost
      });
      final response = await _dioConfig.post('expense/$id', data: formData);
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => ExpensesModel.fromJson(e)).toList(),
          ),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<ExpensesModel>>>> deleteExpenses(
    int id,
  ) async {
    try {
      final response = await _dioConfig.delete('expenses/$id');
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => ExpensesModel.fromJson(e)).toList(),
          ),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<ExpensesModel>>>> searchExpenses(
      String query) async {
    try {
      final response = await _dioConfig.get('expenses?search=$query');
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ExpensesModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
