import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/orders/transfer2storeModel.dart';
import 'package:santexnika_crm/models/retruned_store/returnedStoreModel.dart';
import 'package:santexnika_crm/service/api_service/returnedStore/returnedStore.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';

import '../../sold/cubit/sold_cubit.dart';

part 'returned_store_state.dart';

class ReturnedStoreCubit extends Cubit<ReturnedStoreState> {
  final ReturnedStoreService returnedStoreService = ReturnedStoreService();
  int currentPage = 1;
  bool isMobile = false;

  final PagingController<int, ReturnedStoreModel> pagingController =
      PagingController(firstPageKey: 1);

  BaseModel<List<ReturnedStoreModel>> selectedData = BaseModel(
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

  pageRequest() {
    pagingController.addPageRequestListener((pageKey) {
      print("PAGE KEY $pageKey");
      getReturnedStore(pageKey, '');
    });
  }

  Future<void> refreshReturned() async {
    currentPage = 1;
    pagingController.refresh();
    clearData();
    getReturnedStore(
      currentPage,
      '',
    );
  }

  void disposed() {
    pagingController.dispose();
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

  ReturnedStoreCubit() : super(ReturnedStoreInitial());

  // int totalPage = 0;

  Future<void> getReturnedStore(int page, String query) async {
    !isMobile ? emit(ReturnedStoreLoadingState()) : null;

    try {
      final Either<String, BaseModel<List<ReturnedStoreModel>>> data =
          await returnedStoreService.getReturned(page, query);
      data.fold(
        (error) => emit(
          ReturnedStoreErrorState(error),
        ),
        (data) {
          bool isLastPage = false;
          isLastPage = data.currentPage == data.lastPage;
          selectedData.data.addAll(data.data);
          if (isLastPage) {
            pagingController.appendLastPage(data.data);
            pagingController.notifyStatusListeners(PagingStatus.completed);
            emit(ReturnedStoreSuccessState(selectedData));
          } else {
            final nextPageKey = page + 1;
            pagingController.appendPage(data.data, nextPageKey);
            isMobile
                ? emit(ReturnedStoreSuccessState(selectedData))
                : emit(
                    ReturnedStoreSuccessState(data),
                  );
          }
        },
      );
    } catch (e) {
      emit(
        ReturnedStoreErrorState(
          e.toString(),
        ),
      );
    }
  }
  Future<void> getReturnedDesktopStore(int page, String query) async {
 emit(ReturnedStoreLoadingState()) ;

    try {
      final Either<String, BaseModel<List<ReturnedStoreModel>>> data =
          await returnedStoreService.getReturned(page, query);
      data.fold(
        (error) => emit(
          ReturnedStoreErrorState(error),
        ),
        (data) {
         emit(ReturnedStoreSearchSuccessState(data));
        },
      );
    } catch (e) {
      emit(
        ReturnedStoreErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> postReturnedStore(
      List<Transfer2StoreModel> returedModel, int priceId, int typeId) async {
    emit(ReturnedStoreLoadingState());
    try {
      final Either<String, ReturnedStoreModel> postData =
          await returnedStoreService.postReturned(
              returedModel, priceId, typeId);
      postData.fold(
          (l) => emit(
                ReturnedStoreErrorState(l),
              ), (r) {
        SnackBarWidget()
            .showSnackbar("Muvaffaqiyatli", "Muvaffaqiyatli qaytarildi", 2, 2);
        emit(
          ReturnedStoreSuccessForPostState(r),
        );
      });
    } catch (e) {
      left(ReturnedStoreErrorState(e.toString()));
    }
  }

  Future<void> searchReturnedOnes(String query) async {
    emit(ReturnedStoreLoadingState());

    try {
      final Either<String, BaseModel<List<ReturnedStoreModel>>> search =
          await returnedStoreService.searchReturnedOnes(query);
      search.fold((l) => emit(ReturnedStoreErrorState(l)), (data) {
        data.data.isNotEmpty
            ? emit(
          ReturnedStoreSearchSuccessState(data),
              )
            : ReturnedStoreErrorState(searchError);
      });
    } catch (e) {}
  }
}
