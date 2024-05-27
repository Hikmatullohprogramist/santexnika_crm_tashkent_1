import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/customer/customerModel.dart';
import 'package:santexnika_crm/models/customer/customerWithId.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

class CustomerService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Customer 🟢 🟢 🟢 🟢 🔴 🔴
  Future<Either<String, BaseModel<List<CustomerModel>>>> getCustomer(
      int page, String query) async {
    try {
      final response =
          await _dioConfig.get('customers?page=$page&search=$query');
      if (response.data.isNotEmpty) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => CustomerModel.fromJson(e),
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

  Future<Either<String, String>> deleteCustomer(
      int id) async {
    try {
      final response = await _dioConfig.delete('customer/$id');
      if (response.statusCode==200) {
        return right(
          response.data['message']
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<CustomerWithId>>> getCustomerWithId(int id) async {
    try {
      final response = await _dioConfig.get('customer/$id');

      if (response.statusCode == 200) {
        return right(
          [
            CustomerWithId.fromJson(response.data),
          ],
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, String>> postCustomer(
    String name,
    String phone,
    String comment,
    int branchId,
  ) async {
    try {
      FormData formData = FormData.fromMap(
        {
          'name': name,
          'phone': phone,
          if (comment != "") 'comment': comment,
          'branch_id': branchId,
        },
      );
      final response = await _dioConfig.post('customer', data: formData);
      if (response.statusCode == 200) {
        return right(
          response.data['message'],
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

  Future<Either<String, String>> updateCustomer(String name, String phone,
      String comment, int branchId, int customerId) async {
    try {
      FormData formData = FormData.fromMap(
        {
          'name': name,
          'phone': phone,
          if (comment != "") 'comment': comment,
         },
      );
      final response =
          await _dioConfig.post('customer/update/$customerId', data: formData);
      if (response.statusCode == 200) {
        return right(
          response.data['message'],
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

  Future<Either<String, List<CustomerWithId>>> payCustomer(
    int id,
    int priceId,
    int typeId,
    double price,
    String comment,
  ) async {
    try {
      var data = json.encode({
        "payments": [
          {
            "type_id": typeId,
            "price_id": priceId,
            "comment": comment,
            "price": price
          },
        ]
      });
      // FormData formData = FormData.fromMap({
      //   'price_id': priceId,
      //   'type_id': typeId,
      //   'price': price,
      //   'comment': comment,
      // });
      final response = await _dioConfig.post('customer/$id', data: data);
      if (response.statusCode == 200) {
        return right(
          [
            CustomerWithId.fromJson(response.data),
          ],
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<CustomerWithId>>> addDebtCustomer(
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
          await _dioConfig.post('customer/debt/$id', data: formData);
      if (response.statusCode == 200) {
        return right(
          [
            CustomerWithId.fromJson(response.data),
          ],
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<CustomerModel>>>> searchCustomer(
      String query) async {
    try {
      final response = await _dioConfig.get('customers?search=$query');
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => CustomerModel.fromJson(e)).toList(),
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

  Future<Either<String, String>> updatePayCustomer(
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
      final response = await _dioConfig.post('customer/debt/$companyId/update',
          data: formData);
      if (response.statusCode == 200) {
        return right(
          response.data['message'],
        );
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, String>> deletePayCompany(
    int debt_id,
    int companyId,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'debt_id': debt_id,
      });
      final response = await _dioConfig.post('customer/debt/$companyId/delete',
          data: formData);
      if (response.statusCode == 200) {
        return right(response.data['message']);
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
