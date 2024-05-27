import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:santexnika_crm/models/basket/productsAddModel.dart';
import 'package:santexnika_crm/models/basket/save_basket_model.dart';
import 'package:santexnika_crm/service/api_service/basket_service/basket.dart';

import '../../../../../models/basket/basket.dart';
import 'basket_state.dart';

class BasketCubit extends Cubit<BasketState> {
  final BasketService basketService = BasketService();

  BasketCubit() : super(BasketInitial()) {
    getBasket();
  }

  Future<void> getBasket() async {
    emit(BasketLoading());
    try {
      Either<String, OrderModel> data = await basketService.getBasket();

      data.fold((error) {
        emit(BasketError(error));
      }, (dataa) {
        dataa.basket.isEmpty ? emit(BasketEmpty()) : emit(BasketSuccess(dataa));
      });
    } catch (e) {
      emit(BasketError(e.toString()));
    }
  }

  Future<void> postBasket(
      List<ProductsAddModel> productId, int quantity) async {
    emit(BasketLoading());
    try {
      Either<String, OrderModel> data =
          await basketService.postBasket(productId);

      data.fold((error) {
        print(error);
        emit(BasketError(error));
      }, (dataa) {
        emit(
          dataa.basket.isEmpty
              ? BasketError("Mahsulot yoq")
              : BasketSuccess(dataa),
        );
      });
    } catch (e) {
      emit(BasketError(e.toString()));
    }
  }

  Future<void> deleteBasket(List<int> productId) async {
    emit(BasketLoading());

    try {
      Either<String, OrderModel> data =
          await basketService.deleteBasket(productId);

      data.fold((error) {
        emit(BasketError(error));
      }, (dataa) {
        emit(
          dataa.basket.isEmpty ? BasketEmpty() : BasketSuccess(dataa),
        );
      });
    } catch (e) {
      emit(BasketError(e.toString()));
    }
  }

  saveBasket(List<SavedBasketModel> dataa, double? price, int? priceId,
      int? typeId, String? comment) async {
    emit(BasketLoading());

    try {
      Either<String, dynamic> data = await basketService.saveBasket(
          dataa, price, priceId, typeId, comment);

      data.fold((error) {
        emit(BasketError(error));
      }, (dataTuple) {
        print(dataTuple.runtimeType);
        if (dataTuple is OrderModel) {
          emit(BasketSuccess(dataTuple));
        } else if (dataTuple is int) {
          emit(BasketSuccessCheck(dataTuple.toString()));
        } else {
          emit(BasketError("$dataTuple"));
        }
      });
    } catch (e) {
      emit(
        BasketError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateBasket(
      int productId,
      int priceId,
      double agreedPrice,
      double quantity,
      ) async {
    try {
      Either<String, OrderModel> data = await basketService.updateBasket(
        productId,
        priceId,
        agreedPrice,
        quantity,
      );

      data.fold((error) {
        emit(BasketError(error));
      }, (dataa) {
        emit(
          dataa.basket.isEmpty ? BasketEmpty() : BasketSuccess(dataa),
        );
      });
    } catch (e) {
      emit(BasketError(e.toString()));
    }
  }

}
