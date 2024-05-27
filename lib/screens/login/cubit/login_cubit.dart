// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:meta/meta.dart';
import 'package:santexnika_crm/models/user/error_login_user_model.dart';
import 'package:santexnika_crm/models/user/login_model.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/service/api_service/users/token.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/tools/locator.dart';
import 'package:santexnika_crm/tools/prefs.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final TokenService _tokenService = TokenService();

  LoginCubit() : super(LoginInitial());

  Future<void> getToken(String username, String password) async {
    emit(LoginLoading());

    try {
      final Either<LoginErrorModel, LoginModel> dataa =
          await _tokenService.getToken(
        username,
        password,
      );

      dataa.fold(
        (error) => emit(LoginError(error)),
        (data) async {

          print(data);
          bool success =
              await getIt.get<PrefUtils>().setToken(data.token ?? "");
          if (success) {

            print(success);
            emit(LoginSuccess(data));
            BranchesCubit().getBranches();
          }
        },
      );
    } catch (e) {
      emit(
        LoginError(
          LoginErrorModel(
            success: false,
            message: "Qandaydur xatolik roy berdi",
          ),
        ),
      );
    }
  }

  Future<void> getAuthUser() async {
    emit(LoginLoading());

    try {
      final Either<LoginErrorModel, LoginModel> dataa =
          await _tokenService.getAuthUser();

      dataa.fold(
        (error) => emit(LoginError(error)),
        (data) async {
          // data.userAccess.forEach((element) {
          //   print(element.access.name);
          // });
          // AppConstants.getPages(data.userAccess);

          emit(LoginSuccess(data));
        },
      );
    } catch (e) {
      emit(
        LoginError(
          LoginErrorModel(
            success: false,
            message: "Qandaydur xatolik roy berdi",
          ),
        ),
      );
    }
  }
}
