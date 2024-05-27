
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
 import 'package:santexnika_crm/models/pruduct/calculation_model.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/models/transfer_model.dart';
import 'package:santexnika_crm/service/api_service/product/product.dart';

import '../../../models/base_model.dart';
import '../../../widgets/snek_bar_widget.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final ProductService productService = ProductService();
  int totalPage = 0;
  int currentPage = 1;
  bool isMobile = false;
  final List<bool> selected = [];

  final PagingController<int, ProductModel> pagingController =
      PagingController(firstPageKey: 1);

  BaseModel<List<ProductModel>> selectedData = BaseModel(
      currentPage: 0,
      data: [],
      firstPageUrl: "",
      from: 0,
      lastPage: 0,
      lastPageUrl: "",
      links: [],
      path: "",
      perPage: 0,
      to: 0,
      total: 0);

  StoreCubit() : super(StoreInitial());

  pageRequest(String query) {
    pagingController.addPageRequestListener((pageKey) {
      print("PAGE KEY $pageKey");
      getProduct(pageKey, query);
    });
  }

  void clearData() {
    selectedData = BaseModel(
      currentPage: 0,
      data: [],
      firstPageUrl: "",
      from: 0,
      lastPage: 0,
      lastPageUrl: "",
      links: [],
      path: "",
      perPage: 0,
      to: 0,
      total: 0,
    );
  }

  int calculateRoundedDivision(double total) {
    return (total / 20).ceil();
  }

  Future<void> refreshStore(String query) async {
    currentPage = 1;
    pagingController.refresh();
    clearData();
    getProduct(
      currentPage,
      query,
    );
  }

  void disposed() {
    pagingController.dispose();
  }

  Future<void> getProduct(
    int page,
    String query,
  ) async {
    print("Page number $page");
    bool isLastPage = false;
    try {
      final Either<String, BaseModel<List<ProductModel>>> data =
          await productService.getProduct(page, query);
      data.fold(
        (error) => emit(
          StoreErrorState(
            error,
          ),
        ),
        (dataa) async {
          selected.addAll(List.generate(dataa.total, (i) => false));

          isLastPage = dataa.currentPage == dataa.lastPage;
          print(isLastPage);
          selectedData.data.addAll(dataa.data);

          if (isLastPage) {
            pagingController.appendLastPage(dataa.data);
            pagingController.notifyStatusListeners(PagingStatus.completed);
            emit(StoreSuccessState(selectedData));
          } else {
            final nextPageKey = page + 1;

            print("New page $nextPageKey");
            pagingController.appendPage(dataa.data, nextPageKey);
            isMobile
                ? emit(
                    StoreSuccessState(selectedData),
                  )
                : emit(
                    StoreSuccessState(dataa),
                  );
          }
        },
      );
    } catch (ex) {
      emit(
        StoreErrorState(
          ex.toString(),
        ),
      );
    }
  }

  Future<void> getProductDesktop(
    int page,
    String query,
  ) async {
    try {
      final Either<String, BaseModel<List<ProductModel>>> data =
          await productService.getProduct(page, query);
      data.fold(
          (error) => emit(
                StoreErrorState(
                  error,
                ),
              ), (dataa) async {
        dataa.data.isEmpty
            ? emit(StoreEmptyState())
            : emit(
                StoreSuccessState(dataa),
              );
      });
    } catch (ex) {
      emit(
        StoreErrorState(
          ex.toString(),
        ),
      );
    }
  }

  Future<void> calculateProducts() async {
    try {
      final Either<String, ProductCalculation> data =
          await productService.calculateProducts();
      data.fold(
        (error) => emit(
          StoreErrorState(
            error,
          ),
        ),
        (data) => emit(
          StoreCalculateSuccessState(data),
        ),
      );
    } on DioException catch (ex) {
      emit(
        StoreErrorState(
          ex.toString(),
        ),
      );
    }
  }

  Future<void> searchProduct(
    String query, [
    int page = 1,
  ]) async {
    emit(StoreLoadingState());

    try {
      final Either<String, BaseModel<List<ProductModel>>> data =
          await productService.searchProduct(query, page);
      data.fold(
          (error) => emit(
                StoreErrorState('error'),
              ), (data) {
        emit(
          data.data.isEmpty
              ? StoreErrorState("Qidiruvda topilmadi !")
              : StoreSearchSuccessState(data),
        );
      });
    } catch (e) {
      emit(
        StoreErrorState(
          " e.toString()",
        ),
      );
    }
  }

  Future<void> searchProductMobile(
    String query,
    int page,
  ) async {
    emit(StoreLoadingState());

    try {
      final Either<String, BaseModel<List<ProductModel>>> data =
          await productService.searchProduct(query, page);
      data.fold(
          (error) => emit(
                StoreErrorState('error'),
              ), (data) {
        emit(
          data.data.isEmpty
              ? StoreErrorState("Qidiruvda topilmadi !")
              : StoreSearchSuccessState(data),
        );
      });
    } catch (e) {
      emit(
        StoreErrorState(
          " e.toString()",
        ),
      );
    }
  }

  Future<void> postProduct(
    int categoryId,
    int branchId,
    int priceId,
    String name,
    String madeIn,
    String priceCome,
    String priceSell,
    String priceWholesale,
    String quantity,
    String dangerCount,
    dynamic productImage,
  ) async {
    emit(StoreLoadingState());
    try {
      final Either<String, BaseModel<List<ProductModel>>> postData =
          await productService.postProduct(
        categoryId,
        branchId,
        priceId,
        name,
        madeIn,
        priceCome,
        priceSell,
        priceWholesale,
        quantity,
        dangerCount,
        productImage,
      );
      postData.fold(
        (error) => emit(StoreErrorState(error)),
        (data) {
          emit(
            StoreSuccessState(data),
          );
          SnackBarWidget().showSnackbar(
            "SUCCESS",
            "Muvaffaqiyatli q'shildi",
            2,
            4,
          );
        },
      );
    } catch (e) {
      emit(
        StoreErrorState(e.toString()),
      );
    }
  }

  Future<void> deleteProduct(List<int> id) async {
    emit(StoreLoadingState());

    try {
      final Either<String, BaseModel<List<ProductModel>>> deleteData =
          await productService.deleteProduct(id);
      deleteData.fold(
        (error) => emit(StoreErrorState(error)),
        (data) {
          emit(StoreSuccessState(data));
          SnackBarWidget().showSnackbar(
            "SUCCESS",
            "Muvaffaqiyatli o'chirildi",
            2,
            4,
          );
        },
      );
    } catch (e) {
      emit(
        StoreErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> transfer2Branches(List<TransferModel> products) async {
    emit(StoreLoadingState());

    try {
      final Either<String, BaseModel<List<ProductModel>>> deleteData =
          await productService.transfer2Branch(products);
      deleteData.fold(
        (error) => emit(StoreErrorState(error)),
        (data) {
          emit(StoreSuccessState(data));
          SnackBarWidget().showSnackbar(
            "SUCCESS",
            "Muvaffaqiyatli o'tkazildi",
            2,
            4,
          );
        },
      );
    } catch (e) {
      emit(
        StoreErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateProduct(
    int id,
    int categoryId,
    int branchId,
    int priceId,
    String name,
    String madeIn,
    String priceCome,
    String priceSell,
    String priceWholesale,
    String quantity,
    String dangerCount,
    dynamic productImage,
  ) async {
    emit(StoreLoadingState());
    try {
      final Either<String, BaseModel<List<ProductModel>>> updateData =
          await productService.updateProduct(
        id,
        categoryId,
        branchId,
        priceId,
        name,
        madeIn,
        priceCome,
        priceSell,
        priceWholesale,
        quantity,
        dangerCount,
        productImage ?? '',
      );
      updateData.fold(
          (error) => emit(
                StoreErrorState(error),
              ), (data) {
        emit(
          StoreSuccessState(data),
        );
        SnackBarWidget().showSnackbar(
          "SUCCESS",
          "Muvaffaqiyatli o'zgartirildi",
          2,
          4,
        );
      });
    } catch (e) {
      emit(
        StoreErrorState(
          e.toString(),
        ),
      );
    }
  }

  addProduct(int productId, double amount) async {
    emit(StoreLoadingState());

    try {
      final Either<String, String> data =
          await productService.addProduct(productId, amount);

      data.fold(
          (error) => emit(
                StoreErrorState(error),
              ), (successData) {
        if (successData == "true") {



          SnackBarWidget().showSnackbar(
            "SUCCESS",
            "Muvaffaqiyatli qo'shildi",
            2,
            4,
          );


        }
      });
    } catch (e) {
      print(e.toString);
    }
  }
}
