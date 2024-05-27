import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/service/api_service/access/access.dart';

import '../../../../errors/service_error.dart';
import '../../../../models/access/access_mode.dart';
import '../../../../widgets/snek_bar_widget.dart';

part 'access_state.dart';

class AccessCubit extends Cubit<AccessState> {
  final AccessService accessService = AccessService();

  AccessCubit() : super(AccessInitial()) {
    getAccess();
  }

  Future<void> getAccess() async {
    emit(AccessLoadingState());

    try {
      final Either<String, List<AccessModel>> dataa =
          await accessService.getAccess();
      dataa.fold(
        (error) => emit(
          AccessErrorState(error),
        ),
        (data) => emit(
          data.isNotEmpty ? AccessSuccessState(data) : AccessErrorState(empty),
        ),
      );
    } catch (e) {
      emit(AccessErrorState('error:$e'));
    }
  }

  Future<void> postAccess(String name) async {
    emit(AccessLoadingState());

    try {
      final Either<String, String> postData =
          await accessService.postAccess(name);
      postData.fold(
        (error) => emit(
          AccessErrorState(postError),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
          getAccess();
        },
      );
    } catch (e) {
      left(
        AccessErrorState(postError),
      );
    }
  }
}
