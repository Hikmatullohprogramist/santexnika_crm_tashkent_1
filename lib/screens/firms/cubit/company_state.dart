part of 'company_cubit.dart';

@immutable
abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyLoadingState extends CompanyState {}

class CompanyEmptyState extends CompanyState {}

class CompanySuccessState extends CompanyState {
  final BaseModel<List<CompanyModel>> data;

  CompanySuccessState(this.data);
}

class CompanyErrorState extends CompanyState {
  final String error;

  CompanyErrorState(this.error);
}

abstract class ShowCompanyState {}

class ShowCompanyInitial extends ShowCompanyState {}

class ShowCompanyLoadingState extends ShowCompanyState {}

class ShowCompanySuccessState extends ShowCompanyState {
  final ShowCompanyModel data;

  ShowCompanySuccessState(this.data);
}

class ShowCompanyErrorState extends ShowCompanyState {
  final String error;

  ShowCompanyErrorState(this.error);
}

class ShowCompanyAttachedProducts extends ShowCompanyState {
  final BaseModel<List<ProductModel>> data;

  ShowCompanyAttachedProducts(this.data);
}class ShowCompanyAttachedProductsLoading extends ShowCompanyState {

  ShowCompanyAttachedProductsLoading( );
}class ShowCompanyAttachedProductserror extends ShowCompanyState {

  ShowCompanyAttachedProductserror( );
}
