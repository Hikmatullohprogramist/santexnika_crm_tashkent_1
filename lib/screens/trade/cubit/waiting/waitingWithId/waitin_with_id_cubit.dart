import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../../models/orders/waitingModel.dart';
import '../../../../../service/api_service/waiting/waiting.dart';

part 'waitin_with_id_state.dart';

class WaitingWithIdCubit extends Cubit<WaitingWithIdState> {
  final WaitingOrderService waitingOrderService = WaitingOrderService();

  WaitingWithIdCubit() : super(WaitingWithIdInitial());

  Future<void> getWaitingWithId(int id) async {
    emit(WaitingLoadingWithIdState());
    try {
      Either<String, WaitingModelWithId> data =
          await waitingOrderService.getWaitingWithId(id);
      data.fold(
        (error) => emit(WaitingErrorWithIdState(error)),
        (data) => emit(
          WaitingSuccessWithIdState(data),
        ),
      );
    } catch (e) {
      emit(WaitingErrorWithIdState(e.toString()));
    }
  }

  Future<void> unWaitingWithId(int id) async {
    emit(WaitingLoadingWithIdState());
    try {
      final Either<String, WaitingModelWithId> data =
      await waitingOrderService.unWaiting(id);
      data.fold(
            (l) => emit(WaitingErrorWithIdState(l)),
            (r) => emit(
          WaitingSuccessWithIdState(r),
        ),
      );
    } catch (e) {
      emit(
        WaitingErrorWithIdState(
          e.toString(),
        ),
      );
    }
  }


}
