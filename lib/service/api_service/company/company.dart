// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/company/company_model.dart';
import 'package:santexnika_crm/models/company/showCompanyModel.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';

import 'package:santexnika_crm/tools/dio_configration.dart';

class CompanyService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Company 🟢 🟢 🟢 🟢 🟢  🔴

  Future<Either<String, BaseModel<List<CompanyModel>>>> getCompany(
      int page, int perPage, String search) async {
    try {
      String url = "companies?page=$page&perPage=$perPage";

      if (search.isNotEmpty) {
        url += "&search=$search";
      }
      final response = await _dioConfig.get(url);
      if (response.data.isNotEmpty) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => CompanyModel.fromJson(e),
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

  Future<Either<String, BaseModel<List<CompanyModel>>>> postCompany(
    int branchId,
    String name,
    String phone,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'branch_id': branchId,
        'name': name,
        'phone': phone,
      });
      final response = await _dioConfig.post('company', data: formData);
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => CompanyModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<CompanyModel>>>> updateCompany(
    int branchId,
    String name,
    String phone,
    int id,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'branch_id': branchId,
        'name': name,
        'phone': phone,
      });
      final response =
          await _dioConfig.post('company/update/$id', data: formData);
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => CompanyModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, ShowCompanyModel>> showCompany(int id) async {
    try {
      final response = await _dioConfig.get('company/$id');
      if (response.statusCode == 200) {
        return right(
          ShowCompanyModel.fromJson(response.data),
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

  Future<Either<String, ShowCompanyModel>> payCompany(
    int id,
    int typeId,
    int priceId,
    String comment,
    double price,
  ) async {
    try {
      var data = json.encode({
        "payments": [
          {
            "type_id": typeId,
            "price_id": priceId,
            "comment": comment,
            "price": price
          }
        ]
      });
      // FormData formData = FormData.fromMap({
      //   'price_id': priceId,
      //   'type_id': typeId,
      //   'price': price,
      //   'comment': comment,
      // });
      final response = await _dioConfig.post('company/pay/$id', data: data);
      if (response.statusCode == 200) {
        return right(
          ShowCompanyModel.fromJson(response.data),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, ShowCompanyModel>> updatePayCompany(
    int priceId,
    int typeId,
    double price,
    int debt_id,
    int companyId,
    String comment,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'price_id': priceId,
        'type_id': typeId,
        'price': price,
        'debt_id': debt_id,
        'comment': comment,
      });
      final response = await _dioConfig.post('company/debt/$companyId/update',
          data: formData);
      if (response.statusCode == 200) {
        return right(
          ShowCompanyModel.fromJson(response.data),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, ShowCompanyModel>> deletePayCompany(
    int debt_id,
    int companyId,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'debt_id': debt_id,
      });
      final response = await _dioConfig.post('company/debt/$companyId/delete',
          data: formData);
      if (response.statusCode == 200) {
        return right(
          ShowCompanyModel.fromJson(response.data),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, ShowCompanyModel>> addDebtCompany(
    int id,
    int priceId,
    int typeId,
    double price,
    String comment,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'price_id': priceId,
        'type_id': typeId,
        'price': price,
        'comment': comment,
      });
      final response =
          await _dioConfig.post('company/debt/$id', data: formData);
      if (response.statusCode == 200) {
        return right(
          ShowCompanyModel.fromJson(response.data),
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<CompanyModel>>>> deleteCompany(
    int id,
  ) async {
    try {
      final response = await _dioConfig.delete('company/$id');
      if (response.statusCode == 200) {
        if (response.data['message'] == "Company has debts") {
          return left(response.data['message']);
        } else {
          return right(
            BaseModel.fromJson(
              response.data,
              (data) => (data as List)
                  .map(
                    (e) => CompanyModel.fromJson(e),
                  )
                  .toList(),
            ),
          );
        }
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

  Future<Either<String, String>> attachProduct(
    int companyId,
    List<int> productIds,
  ) async {
    try {
      var data = json.encode({
        "stores": productIds.map((e) => {"store_id": e}).toList()
      });
      final response =
          await _dioConfig.post('company/$companyId/stores/attach', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data["success"]) {
          return right("Muvaffaqiyatli, biriktirildi");
        } else {
          return left(response.statusMessage ?? response.statusCode.toString());
        }
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

  Future<Either<String, ShowCompanyModel>> addProduct(
    int companyId,
    int storeId,
    double qty,
  ) async {
    try {
      var data = FormData.fromMap({'store_id': storeId, 'qty': qty});

      final response =
          await _dioConfig.post('company/$companyId/stores/add', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(ShowCompanyModel.fromJson(response.data));
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

  Future<Either<String, BaseModel<List<ProductModel>>>> getAttachedProducts(
    int companyId,
      int page
  ) async {
    try {
      final response = await _dioConfig.get('company/$companyId/stores?page=$page');
      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ProductModel.fromJson(e),
                )
                .toList(),
          ),
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
