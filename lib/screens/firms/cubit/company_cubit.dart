import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/company/company_model.dart';
import 'package:santexnika_crm/models/company/showCompanyModel.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/service/api_service/company/company.dart';

import '../../../errors/service_error.dart';
import '../../../widgets/snek_bar_widget.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyService companyService = CompanyService();

  CompanyCubit() : super(CompanyInitial());
  int totalPage = 0;

  Future<void> getCompany(int page, [int perPage = 10,String search='']) async {
    emit(CompanyLoadingState());

    try {
      final Either<String, BaseModel<List<CompanyModel>>> data =
          await companyService.getCompany(page, perPage, search);
      data.fold(
        (error) => emit(CompanyErrorState(error)),
        (data) => emit(
          data.data.isEmpty ? CompanyEmptyState() : CompanySuccessState(data),
        ),
      );
    } catch (e) {
      emit(
        CompanyErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> postCompany(
    int branchId,
    String name,
    String phone,
  ) async {
    emit(CompanyLoadingState());

    try {
      final Either<String, BaseModel<List<CompanyModel>>> postData =
          await companyService.postCompany(branchId, name, phone);
      postData.fold(
        (error) => emit(
          CompanyErrorState(error),
        ),
        (data) {
          emit(CompanySuccessState(data));
          SnackBarWidget().showSnackbar("SUCCESS", "Qo'shildi", 2, 4);
        },
      );
    } catch (e) {
      left(
        CompanyErrorState(e.toString()),
      );
    }
  }

  Future<void> updateCompany(
    int branchId,
    String name,
    String phone,
    int id,
  ) async {
    emit(CompanyLoadingState());

    try {
      final Either<String, BaseModel<List<CompanyModel>>> updateData =
          await companyService.updateCompany(branchId, name, phone, id);
      updateData.fold(
        (error) => emit(
          CompanyErrorState(error),
        ),
        (data) {
          emit(CompanySuccessState(data));
          SnackBarWidget().showSnackbar("SUCCESS", "O'zgartirildi", 2, 4);
        },
      );
    } catch (e) {
      left(
        CompanyErrorState(e.toString()),
      );
    }
  }

  Future<void> deleteCompany(int id) async {
    emit(CompanyLoadingState());

    try {
      final Either<String, BaseModel<List<CompanyModel>>> data =
          await companyService.deleteCompany(id);
      data.fold(
        (l) {
          SnackBarWidget()
              .showSnackbar("Muvaffaqiyatsizlik", "Firmani qarzi bor", 2, 4);

          getCompany(0);
        },
        (data) {
          SnackBarWidget().showSnackbar(
              "Muvaffaqiyatlik", "muvaffaqiyatlik o'chirildi", 2, 4);
          emit(
            data.data.isEmpty ? CompanyEmptyState() : CompanySuccessState(data),
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> attachProduct(int companyId, List<int> productIds) async {
    emit(CompanyLoadingState());

    try {
      final Either<String, String> data =
          await companyService.attachProduct(companyId, productIds);
      data.fold(
        (l) {
          SnackBarWidget().showSnackbar("Muvaffaqiyatsizlik", l, 2, 4);

          getCompany(0);
        },
        (data) {
          SnackBarWidget().showSnackbar(
            "Muvaffaqiyatlik",
            data,
            2,
            4,
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class ShowCompanyCubit extends Cubit<ShowCompanyState> {
  final CompanyService companyService = CompanyService();

  ShowCompanyCubit() : super(ShowCompanyInitial());

  Future<void> showCompany(int id) async {
    emit(ShowCompanyLoadingState());
    try {
      final Either<String, ShowCompanyModel> postData =
          await companyService.showCompany(id);
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) => emit(data.data.isNotEmpty
            ? ShowCompanySuccessState(data)
            : ShowCompanyErrorState(empty)),
      );
    } catch (e) {
      emit(ShowCompanyErrorState(
        e.toString(),
      ));
    }
  }

  Future<void> payCompany(
    int id,
    int typeId,
    int priceId,
    String comment,
    double price,
  ) async {
    emit(ShowCompanyLoadingState());
    try {
      final Either<String, ShowCompanyModel> postData =
          await companyService.payCompany(id, typeId, priceId, comment, price);
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) => emit(ShowCompanySuccessState(data)),
      );
    } catch (e) {
      left(
        ShowCompanyErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updatePayCompany(
    int priceId,
    int typeId,
    double price,
    int debt_id,
    int companyId,
    String comment,
  ) async {
    emit(ShowCompanyLoadingState());
    try {
      final Either<String, ShowCompanyModel> postData =
          await companyService.updatePayCompany(
              priceId, typeId, price, debt_id, companyId, comment);
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) => emit(ShowCompanySuccessState(data)),
      );
    } catch (e) {
      left(
        ShowCompanyErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deletePayCompany(
    int debt_id,
    int companyId,
  ) async {
    emit(ShowCompanyLoadingState());
    try {
      final Either<String, ShowCompanyModel> postData =
          await companyService.deletePayCompany(debt_id, companyId);
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) => emit(ShowCompanySuccessState(data)),
      );
    } catch (e) {
      left(
        ShowCompanyErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> addDebtCompany(
    int id,
    int priceId,
    int typeId,
    double price,
    String comment,
  ) async {
    emit(ShowCompanyLoadingState());
    try {
      final Either<String, ShowCompanyModel> postData =
          await companyService.addDebtCompany(
        id,
        priceId,
        typeId,
        price,
        comment,
      );
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) {
          data.data.isEmpty
              ? emit(ShowCompanyErrorState(empty))
              : emit(ShowCompanySuccessState(data));
        },
      );
    } catch (e) {
      left(
        ShowCompanyErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> addProduct(int storeId, int companyId, double qty) async {
    emit(ShowCompanyLoadingState());
    try {
      final Either<String, ShowCompanyModel> postData =
          await companyService.addProduct(companyId, storeId, qty);
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) {
          data.data.isEmpty
              ? emit(ShowCompanyErrorState(empty))
              : emit(ShowCompanySuccessState(data));

          getAttachedProducts(companyId,1);
        },
      );
    } catch (e) {
      left(
        ShowCompanyErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getAttachedProducts(int companyId, int page) async {
    emit(ShowCompanyAttachedProductsLoading());
    try {
      final Either<String, BaseModel<List<ProductModel>>> postData =
          await companyService.getAttachedProducts(
        companyId,
            page
      );
      postData.fold(
        (error) => emit(ShowCompanyErrorState(error)),
        (data) {
          data.data.isEmpty
              ? emit(ShowCompanyErrorState(empty))
              : emit(ShowCompanyAttachedProducts(data));
        },
      );
    } catch (e) {
      left(
        ShowCompanyErrorState(
          e.toString(),
        ),
      );
    }
  }
}
