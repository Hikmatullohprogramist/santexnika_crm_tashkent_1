import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/customer/customerModel.dart';
import 'package:santexnika_crm/models/customer/customerWithId.dart';
import 'package:santexnika_crm/service/api_service/customer/customer.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerService customerService = CustomerService();

  CustomerCubit() : super(CustomerInitial());
  int totalPage = 0;
  BaseModel<List<CustomerModel>> dataa = BaseModel(
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

  void clearData() {
    dataa = BaseModel(
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

  Future<void> getCustomer(int page, String query,
      {bool fromLoading = false, bool isMobile = false}) async {
    if (fromLoading) {
      emit(CustomerForPaginationLoadingState());
    } else {
      emit(CustomerLoadingState());
    }
    try {
      final Either<String, BaseModel<List<CustomerModel>>> data =
          await customerService.getCustomer(page, query);
      data.fold(
          (error) => emit(
                CustomerErrorState(error),
              ), (data) async {
        if (data.data.isNotEmpty) {
          dataa.data.addAll(data.data);
          emit(CustomerSuccessState(isMobile ? dataa : data));
        } else {
          if (fromLoading) {
            emit(
              CustomerForPaginationErrorState(empty),
            );
            await Future.delayed(const Duration(seconds: 1));
            emit(CustomerInitial());
          } else {
            emit(
              CustomerErrorState(empty),
            );
          }
        }
      });
    } catch (e) {
      emit(
        CustomerErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> searchCustomer(String query) async {
    emit(CustomerLoadingState());
    try {
      final Either<String, BaseModel<List<CustomerModel>>> data =
          await customerService.searchCustomer(query);
      data.fold(
        (error) => emit(CustomerErrorState(error)),
        (data) => emit(
          data.data.isNotEmpty
              ? CustomerSuccessState(data)
              : CustomerErrorState(searchError),
        ),
      );
    } catch (e) {
      emit(
        CustomerErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> postCustomer(
    String name,
    String phone,
    String comment,
    int branchId,
  ) async {
    emit(CustomerErrorState(postError));
    try {
      final Either<String, String> postData =
          await customerService.postCustomer(
        name,
        phone,
        comment,
        branchId,
      );
      postData.fold(
        (error) {
          emit(CustomerErrorState(error));
        },
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
          emit(
            CustomerSuccessForPostState(data),
          );
        },
      );
    } catch (e) {
      emit(
        CustomerErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateCustomer(String name, String phone, String comment,
      int branchId, int customerId) async {
    emit(CustomerErrorState(postError));
    try {
      final Either<String, String> postData = await customerService
          .updateCustomer(name, phone, comment, branchId, customerId);
      postData.fold(
        (error) => emit(
          CustomerErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
        },
      );
    } catch (e) {
      emit(
        CustomerErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deleteCustomer(int id) async {
    emit(CustomerErrorState(postError));
    try {
      final Either<String, String> postData =
          await customerService.deleteCustomer(id);
      postData.fold(
        (error) => emit(
          CustomerErrorState(error),
        ),
        (data) {
          if (data == 'Customer has debts') {
            SnackBarWidget().showSnackbar("Xatolik", 'Mijozni qarzi bor', 2, 4);
            emit(
              CustomerSuccessForPostState(data),
            );
          }else{
            SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
            emit(
              CustomerSuccessForPostState(data),
            );
          }

        },
      );
    } catch (e) {
      emit(
        CustomerErrorState(
          e.toString(),
        ),
      );
    }
  }
}

class CustomerWithIdCubit extends Cubit<CustomerWithIdState> {
  final CustomerService customerService = CustomerService();

  CustomerWithIdCubit() : super(CustomerWithIdInitial()) {}

  Future<void> getCustomerWithId(int id) async {
    emit(CustomerLoadingWithIdState());

    try {
      final Either<String, List<CustomerWithId>> data =
          await customerService.getCustomerWithId(
        id,
      );
      data.fold(
        (error) => emit(
          CustomerErrorWithIdState(error),
        ),
        (data) => data.isNotEmpty
            ? emit(
                CustomerSuccessWithIdState(data),
              )
            : emit(
                CustomerErrorWithIdState(empty),
              ),
      );
    } catch (e) {
      emit(
        CustomerErrorWithIdState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> payCustomer(
    int id,
    int priceId,
    int typeId,
    double price,
    String comment,
  ) async {
    emit(CustomerLoadingWithIdState());
    try {
      final Either<String, List<CustomerWithId>> postData =
          await customerService.payCustomer(
        id,
        priceId,
        typeId,
        price,
        comment,
      );
      postData.fold(
        (error) => emit(CustomerErrorWithIdState(error)),
        (data) => emit(CustomerSuccessWithIdState(data)),
      );
    } catch (e) {
      left(
        CustomerErrorWithIdState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> addDebtCustomer(
    int id,
    int priceId,
    int typeId,
    double price,
    String comment,
  ) async {
    emit(CustomerLoadingWithIdState());
    try {
      final Either<String, List<CustomerWithId>> postData =
          await customerService.addDebtCustomer(
        id,
        priceId,
        typeId,
        price,
        comment,
      );
      postData.fold(
        (error) => emit(CustomerErrorWithIdState(error)),
        (data) => emit(CustomerSuccessWithIdState(data)),
      );
    } catch (e) {
      left(
        CustomerErrorWithIdState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updatePayCustomer(
    int priceId,
    int typeId,
    double price,
    int debt_id,
    int companyId,
    String comment,
  ) async {
    emit(CustomerLoadingWithIdState());
    try {
      final Either<String, String> postData =
          await customerService.updatePayCustomer(
        priceId,
        typeId,
        price,
        debt_id,
        companyId,
        comment,
      );
      postData.fold((error) => emit(CustomerErrorWithIdState(error)), (data) {
        emit(
          CustomerWithIdSuccessPost(
            data,
          ),
        );
        SnackBarWidget().showSnackbar('Success', data, 4, 2);
      });
    } catch (e) {
      left(
        CustomerErrorWithIdState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deletePayCustomer(
    int debt_id,
    int companyId,
  ) async {
    emit(CustomerLoadingWithIdState());
    try {
      final Either<String, String> postData =
          await customerService.deletePayCompany(debt_id, companyId);
      postData.fold(
        (error) => emit(CustomerErrorWithIdState(error)),
        (data) => emit(CustomerWithIdSuccessPost(data)),
      );
    } catch (e) {
      left(
        CustomerErrorWithIdState(
          e.toString(),
        ),
      );
    }
  }
}
