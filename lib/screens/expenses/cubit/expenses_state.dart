part of 'expenses_cubit.dart';

@immutable
abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoadingState extends ExpensesState {}

class ExpensesSuccessState extends ExpensesState {
  final BaseModel<List<ExpensesModel>> data;

  ExpensesSuccessState(this.data);
}
class ExpensesSearchSuccessState extends ExpensesState {
  final BaseModel<List<ExpensesModel>> data;

  ExpensesSearchSuccessState(this.data);
}

class ExpensesErrorState extends ExpensesState {
  final String error;

  ExpensesErrorState(this.error);
}
