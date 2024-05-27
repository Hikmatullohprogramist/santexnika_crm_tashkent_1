import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/service/api_service/users/token.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';

import '../../../../errors/service_error.dart';
import '../../../../models/user/user_payment.dart';
import '../../../../models/user/usersModel.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final TokenService _tokenService = TokenService();

  UsersCubit() : super(UserInitial());

  Future<void> getUsers() async {
    emit(UserLoadingState());

    try {
      final Either<String, BaseModel<List<UsersModel>>> dataa =
          await _tokenService.getUsers();
      dataa.fold(
        (error) => emit(UserErrorState('error')),
        (data) => emit(
          data.data.isNotEmpty ? UserSuccessState(data) : UserEmptyState(),
        ),
      );
    } catch (e) {
      emit(UserErrorState("Qandaydur xatolik bor"));
    }
  }

  Future<void> postUser(
    String name,
    String phone,
    String password,
    List<int> accessId,
    int branchId,
    int userType,
  ) async {
    try {
      final Either<String, String> postData = await _tokenService.postUsers(
        name,
        phone,
        password,
        accessId,
        branchId,
        userType,
      );
      postData.fold(
        (error) => emit(
          UserErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
          getUsers();
        },
      );
    } catch (e) {
      left(
        UserErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateUser(String name, String phone, String password,
      List<int> accessId, int branchId, int userType, int userId) async {
    try {
      final Either<String, String> postData =
          await _tokenService.updateUser(
              name, phone, password, accessId, branchId, userType, userId);
      postData.fold(
        (error) => emit(
          UserErrorState(error),
        ),
        (data) async {
          SnackBarWidget()
              .showSnackbar("SUCCESS", data, 2, 4);


          await getUsers();

          },
      );
    } catch (e) {
      left(
        UserErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deleteUser(int id) async {
    emit(UserLoadingState());

    try {
      final Either<String, BaseModel<List<UsersModel>>> dataa =
          await _tokenService.deleteUser(id);
      dataa.fold(
        (error) => emit(UserErrorState('error')),
        (data) => emit(
          data.data.isNotEmpty ? UserSuccessState(data) : UserErrorState(empty),
        ),
      );
    } catch (e) {
      emit(UserErrorState("Qandaydur xatolik bor"));
    }
  }

  getUserPaymentHistory(int id) async {
    try {
      Either<String, UserPayment> data = await _tokenService.userPayments(id);
      data.fold(
        (l) => UserPaymentErrorState(l),
        (r) => r.data.isEmpty
            ? emit(UserPaymentErrorState(empty))
            : emit(UserPaymentSuccessState(r)),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  postUserPaymentHistory(double price, String comment, int id) async {
    try {
      Either<String, UserPayment> data =
          await _tokenService.postPayment(price, comment, id);
      data.fold(
        (l) => UserPaymentErrorState(l),
        (r) => r.data.isEmpty
            ? emit(UserPaymentErrorState(empty))
            : emit(UserPaymentSuccessState(r)),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  updateUserPaymentHistory(
      double price, String comment, int id, int paymentId) async {
    try {
      Either<String, UserPayment> data =
          await _tokenService.updatePayment(price, comment, id, paymentId);
      data.fold(
        (l) => UserPaymentErrorState(l),
        (r) => r.data.isEmpty
            ? emit(UserPaymentErrorState(empty))
            : emit(UserPaymentSuccessState(r)),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteUserPaymentHistory(int paymentId, int id) async {
    try {
      Either<String, UserPayment> data =
          await _tokenService.deletePayment(id, paymentId);
      data.fold(
        (l) => UserPaymentErrorState(l),
        (r) => r.data.isEmpty
            ? emit(UserPaymentErrorState(empty))
            : emit(UserPaymentSuccessState(r)),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
