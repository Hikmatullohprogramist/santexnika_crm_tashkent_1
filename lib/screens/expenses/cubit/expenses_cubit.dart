import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/service/api_service/expenses/expenses.dart';

import '../../../models/expenses/expenses.dart';
import '../../../widgets/snek_bar_widget.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final ExpensesSerice expensesService = ExpensesSerice();
  var isMobile = false;
  var searchQuery = '';
  int currentPage = 1;
  BaseModel<List<ExpensesModel>> selectedData = BaseModel(
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

  final PagingController<int, ExpensesModel> pagingController =
      PagingController(firstPageKey: 1);

  ExpensesCubit() : super(ExpensesInitial());

  pageRequest() {
    pagingController.addPageRequestListener((pageKey) {
      getExpenses(pageKey, '');
    });
  }

  Future<void> refreshExpanses() async {
    currentPage = 1;
    pagingController.refresh();
    getExpenses(
      currentPage,
      '',
    );
  }

  int calculateRoundedDivision(double total) {
    return (total / 20).ceil();
  }

  Future<void> getExpenses(int page, String query) async {
    !isMobile ? emit(ExpensesLoadingState()) : null;
    try {
      final Either<String, BaseModel<List<ExpensesModel>>> data =
          await expensesService.getExpenses(page, query);
      data.fold(
        (error) => emit(
          ExpensesErrorState(error),
        ),
        (dataa) {
          var isLastPage = false;
          isLastPage = dataa.currentPage == dataa.lastPage;
          selectedData.data.addAll(dataa.data);
          print(dataa.data.length);
          if (isLastPage) {
            pagingController.appendLastPage(dataa.data);
          } else {
            final nextPageKey = page + 1;
            pagingController.appendPage(dataa.data, nextPageKey);
          }
          isMobile
              ? emit(ExpensesSuccessState(selectedData))
              : emit(ExpensesSuccessState(dataa));
        },
      );
    } catch (e) {
      emit(
        ExpensesErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> postExpense(
    String name,
    String comment,
    int typeId,
    int priceId,
    String cost,
  ) async {
    emit(ExpensesLoadingState());
    try {
      final Either<String, BaseModel<List<ExpensesModel>>> postData =
          await expensesService.postExpenses(
        name,
        comment,
        typeId,
        priceId,
        cost,
      );
      postData.fold(
        (error) => emit(
          ExpensesErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", 'Created', 2, 4);

          emit(ExpensesSuccessState(data));
        },
      );
    } catch (e) {
      emit(
        ExpensesErrorState(e.toString()),
      );
    }
  }

  Future<void> putExpense(
    int id,
    String name,
    String comment,
    int typeId,
    int priceId,
    String cost,
  ) async {
    emit(ExpensesLoadingState());
    try {
      final Either<String, BaseModel<List<ExpensesModel>>> postData =
          await expensesService.updateExpenses(
        id,
        name,
        comment,
        typeId,
        priceId,
        cost,
      );
      postData.fold(
        (error) => emit(
          ExpensesErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", 'Update', 2, 4);

          emit(ExpensesSuccessState(data));
        },
      );
    } catch (e) {
      emit(
        ExpensesErrorState(e.toString()),
      );
    }
  }

  Future<void> deleteExpense(
    int id,
  ) async {
    emit(ExpensesLoadingState());
    try {
      final Either<String, BaseModel<List<ExpensesModel>>> postData =
          await expensesService.deleteExpenses(
        id,
      );
      postData.fold(
        (error) => emit(
          ExpensesErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", 'Deleted', 2, 4);

          emit(ExpensesSuccessState(data));
        },
      );
    } catch (e) {
      emit(
        ExpensesErrorState(e.toString()),
      );
    }
  }

  Future<void> searchExpenses(String query) async {
    emit(ExpensesLoadingState());
    try {
      final Either<String, BaseModel<List<ExpensesModel>>> data =
          await expensesService.searchExpenses(query);
      data.fold(
        (l) => emit(ExpensesErrorState(l)),
        (r) {
          r.data.isNotEmpty
              ? emit(ExpensesSearchSuccessState(r))
              : emit(ExpensesErrorState(searchError));
        },
      );
    } catch (e) {
      left(ExpensesErrorState(e.toString()));
    }
  }
}
