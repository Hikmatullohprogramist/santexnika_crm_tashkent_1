// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/user/error_login_user_model.dart';
import 'package:santexnika_crm/models/user/login_model.dart';
import 'package:santexnika_crm/models/user/user_payment.dart';
import 'package:santexnika_crm/service/api_service/wrap_response.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

import '../../../models/user/usersModel.dart';
import '../../../tools/handle_errors.dart';

class TokenService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Token 🟢 🟢 🔴 🔴 🔴

  Future<Either<LoginErrorModel, LoginModel>> getToken(
    String username,
    String password,
  ) async {
    try {
      var data = FormData.fromMap({'login': username, 'password': password});
      final response = await _dioConfig.post("login", data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = response.data;
        if (data != null) {
          return right(LoginModel.fromJson(data));
        } else {
          return left(LoginErrorModel.fromJson(response.data));
        }
      } else if (response.statusCode == 400) {
        return left(
          LoginErrorModel(
            success: false,
            message: "Login yoki parolda xatolik",
            data: Data(
              password: [],
            ),
          ),
        );
      } else {
        return left(LoginErrorModel.fromJson(response.data));
      }
    } catch (e) {
      return left(
        LoginErrorModel(
          success: false,
          message: "Qandaydur xatolik roy berdi",
        ),
      );
    }
  }

  Future<Either<LoginErrorModel, LoginModel>> getAuthUser() async {
    try {
      final response = await _dioConfig.get("user");

      if (response.statusCode == 200) {
        var data = response.data;
        if (data != null) {
          return right(LoginModel.fromJson(data));
        } else {
          return left(LoginErrorModel.fromJson(response.data));
        }
      } else if (response.statusCode == 400) {
        return left(
          LoginErrorModel(
            success: false,
            message: "Ro'yxatdan o'tgan foydalanuvchini olib bo'lmadi",
            data: Data(
              password: [],
            ),
          ),
        );
      } else {
        return left(LoginErrorModel.fromJson(response.data));
      }
    } catch (e) {
      return left(
        LoginErrorModel(
          success: false,
          message: "Qandaydur xatolik roy berdi",
        ),
      );
    }
  }

  Future<Either<String, BaseModel<List<UsersModel>>>> getUsers() async {
    try {
      final response = await _dioConfig.get('users');

      if (response.data.isNotEmpty) {
        return right(BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => UsersModel.fromJson(e)).toList()));
      } else {
        return left("Qandaydur xatolik bor");
      }
    } catch (e) {
      HandleError().handleError(e);

      return left('error:' + e.toString());
    }
  }

  Future<Either<String, String>> postUsers(
    String name,
    String phone,
    String password,
    List<int> accessId,
    int branchId,
    int userType,
  ) async {
    try {
      final response = await _dioConfig.post(
        'user',
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          'access_id': accessId,
          'branch_id': branchId,
          'role': userType,
        },
      );
      if (response.statusCode == 201) {
        return right("Muvaffaqiyatli");
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, String>> updateUser(
    String name,
    String phone,
    String password,
    List<int> accessId,
    int branchId,
    int userType,
    int userId,
  ) async {
    try {
      final response = await _dioConfig.post(
        'user/$userId',
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          'access_id': accessId,
          'branch_id': branchId,
          'role': userType,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(response.data["message"]);
      } else {
        return left(postError);
      }
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  Future<Either<String, BaseModel<List<UsersModel>>>> deleteUser(int id) async {
    try {
      final response = await _dioConfig.delete('user/$id');
      if (response.data.isNotEmpty) {
        return right(response.data);
      } else {
        return right(BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => UsersModel.fromJson(e)).toList()));
      }
    } catch (e) {
      HandleError().handleError(e);

      return left('error:' + e.toString());
    }
  }

  Future<Either<String, UserPayment>> userPayments(int id) async {
    try {
      final response = await _dioConfig.get('user/$id/history');

      if (response.data.isNotEmpty) {
        return right(UserPayment.fromJson(response.data));
      } else {
        return left(
            "Qandaydur xatolik bor ${response.statusMessage.toString()}");
      }
    } catch (e) {
      HandleError().handleError(e);

      return left('error:' + e.toString());
    }
  }

  Future<Either<String, UserPayment>> postPayment(
      double price, String comment, int id) async {
    var data = FormData.fromMap({'price': price, 'comment': comment});

    try {
      final response = await _dioConfig.post('user/$id/payment', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(UserPayment.fromJson(response.data));
      } else {
        return left(
            "Qandaydur xatolik bor ${response.statusMessage.toString()}");
      }
    } catch (e) {
      HandleError().handleError(e);

      return left('error:' + e.toString());
    }
  }

  Future<Either<String, UserPayment>> updatePayment(
      double price, String comment, int id, int paymentId) async {
    var data = FormData.fromMap({
      'price': price,
      'comment': comment,
      'payment_id': paymentId,
    });

    try {
      final response =
          await _dioConfig.post('user/$id/payment/update', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(UserPayment.fromJson(response.data));
      } else {
        return left(
            "Qandaydur xatolik bor ${response.statusMessage.toString()}");
      }
    } catch (e) {
      HandleError().handleError(e);

      return left('error:' + e.toString());
    }
  }

  Future<Either<String, UserPayment>> deletePayment(
      int id, int paymentId) async {
    try {
      final response = await _dioConfig.delete('user/$id/payment/$paymentId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(UserPayment.fromJson(response.data));
      } else {
        return left(
            "Qandaydur xatolik bor ${response.statusMessage.toString()}");
      }
    } catch (e) {
      HandleError().handleError(e);

      return left('error:' + e.toString());
    }
  }
}
