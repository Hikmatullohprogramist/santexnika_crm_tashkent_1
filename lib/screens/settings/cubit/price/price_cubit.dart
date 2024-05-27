// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/price/priceModel.dart';
import 'package:santexnika_crm/service/api_service/price/price.dart';

import '../../../../widgets/snek_bar_widget.dart';

part 'price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  final PriceService priceService = PriceService();

  PriceCubit() : super(PriceInitial()) {
    getPrice();
  }

  Future<void> getPrice() async {
    emit(
      PriceLoadingState(),
    );

    try {
      final Either<String, List<PriceModel>> dataa =
          await priceService.getPrice();
      dataa.fold(
        (error) => emit(
          PriceErrorState('error'),
        ),
        (data) => emit(data.isNotEmpty?PriceSuccessState(data):PriceErrorState(empty)),
      );
    } catch (e) {
      emit(
        PriceErrorState('error'),
      );
    }
  }

  Future<void> postPrice(String name) async {
    emit(PriceLoadingState());

    try {
      final Either<String, String> postData =
          await priceService.postPrice(name);

      postData.fold(
        (error) => emit(
          PriceErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
          getPrice();
        },
      );
    } catch (e) {
      emit(
        PriceErrorState(e.toString()),
      );
    }
  }

  Future<void> updatePrice(int id, String name, double value) async {
    emit(PriceLoadingState());

    try {
      final Either<String, List<PriceModel>> data =
          await priceService.updatePrice(
        id,
        name,
        value,
      );
      data.fold(
        (error) => emit(PriceErrorState(error)),
        (data) => emit(
          PriceSuccessState(data),
        ),
      );
    } catch (e) {
      emit(
        PriceErrorState(
          e.toString(),
        ),
      );
    }
  }
}
