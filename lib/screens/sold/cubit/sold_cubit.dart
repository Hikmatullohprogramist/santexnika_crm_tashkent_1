import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/orders/ordersModel.dart';
import 'package:santexnika_crm/service/api_service/orders/orders.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';

import '../../../models/orders/orderWithIdModel.dart';
import '../../../models/orders/selled_products.dart';

part 'sold_state.dart';

class SoldCubit extends Cubit<SoldState> {
  final OrdersService ordersService = OrdersService();
  BaseModel<List<OrdersModel>> soldItems = BaseModel(
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
  int currentPage = 1;
  bool hasReachedMax = false;
  bool isMobile = false;
  String _searchQuery = "";

  final PagingController<int, OrdersModel> pagingController =
      PagingController(firstPageKey: 1);

  SoldCubit() : super(SoldInitial());

  pageRequest(String query) {
    pagingController.addPageRequestListener((pageKey) {
      getSold(pageKey, query);
    });
  }

  void updateSearchTerm(String searchTerm) {
    _searchQuery = searchTerm;
    refreshSold(_searchQuery);
  }

  int totalPage = 0;

  int calculateRoundedDivision(double total) {
    return (total / 20).ceil();
  }

  Future<void> refreshSold(String query) async {
    currentPage = 1;
    pagingController.refresh();
    hasReachedMax = false;
    emit(SoldInitial());
    getSold(
      currentPage,
      query,
    );
  }

  void dispose() {
    pagingController.dispose();
    super.close();
  }

  Future<void> getSold(
    int page,
    String query,
  ) async {
    if (hasReachedMax) return;

    if (state == SoldInitial || state == SoldErrorState) {
      emit(SoldLoadingState());
    }

    try {
      final Either<String, BaseModel<List<OrdersModel>>> data =
          await ordersService.getOrders(page, query);

      data.fold(
        (error) => emit(SoldErrorState(error)),
        (dataa) {
          if (dataa.currentPage == dataa.lastPage) {
            pagingController.appendLastPage(dataa.data);
            pagingController.notifyStatusListeners(PagingStatus.completed);
            hasReachedMax = true;
          } else {
            final nextPageKey = page + 1;
            soldItems.data.addAll(dataa.data);
            pagingController.appendPage(dataa.data, nextPageKey);
          }
          isMobile
              ? emit(SoldSuccessState(soldItems))
              : emit(SoldSuccessState(dataa));
        },
      );
    } catch (e) {
      emit(SoldErrorState(e.toString()));
    }
  }

  Future<void> getSoldDesktop(
    int page,
    String query,
  ) async {
    emit(SoldLoadingState());

    try {
      final Either<String, BaseModel<List<OrdersModel>>> data =
          await ordersService.getOrders(page, query);

      data.fold(
        (error) => emit(SoldErrorState(error)),
        (dataa) {
          if (dataa.data.isEmpty) {
            emit(SoldErrorState("Ma'lumotlar yo'q"));
          } else {
            emit(SoldSuccessState(dataa));
          }
        },
      );
    } catch (e) {
      emit(SoldErrorState(e.toString()));
    }
  }

  //search
  Future<void> searchSold(String query) async {
    emit(SoldLoadingState());
    try {
      final Either<String, BaseModel<List<OrdersModel>>> data =
          await ordersService.searchSold(query);
      data.fold(
        (error) => emit(
          SoldErrorState(error),
        ),
        (data) {
          data.data.isNotEmpty
              ? emit(
                  SoldSearchSuccessState(data),
                )
              : emit(SoldErrorState(searchError));
        },
      );
    } catch (e) {
      left(
        e.toString(),
      );
    }
  }

  Future<void> getSelledProducts(String query, page) async {
    emit(SoldLoadingState());
    try {
      final Either<String, BaseModel<List<SelledProducts>>> data =
          await ordersService.getSelledProducts(query, page);
      data.fold(
          (error) => emit(
                SoldErrorState(error),
              ), (data) {
        data.data.isNotEmpty
            ? emit(
                SoldProductsSuccessState(data),
              )
            : emit(SoldProductsErrorState(searchError));
      });
    } catch (e) {
      left(
        e.toString(),
      );
    }
  }

  Future<void> getSoldWithId(int page, int id) async {
    emit(SoldLoadingState());
    try {
      final Either<String, OrderWithIdModel> data =
          await ordersService.getOrdersWithId(page, id);
      data.fold(
        (error) => emit(
          SoldErrorState(error),
        ),
        (data) {
          data.data!.baskets!.isNotEmpty
              ? emit(
                  SoldWithIDSuccess(data),
                )
              : emit(
                  SoldEmptyState(),
                );
        },
      );
    } catch (e) {
      left(
        e.toString(),
      );
    }
  }
}
