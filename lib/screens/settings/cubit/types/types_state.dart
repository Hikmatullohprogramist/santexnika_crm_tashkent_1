part of 'types_cubit.dart';

@immutable
abstract class TypesState {}

class TypesInitial extends TypesState {}

class TypesLoadingState extends TypesState {}

class TypesSuccessState extends TypesState {
  final List<TypesModel> data;

  TypesSuccessState(this.data);
}

class TypesErrorState extends TypesState {
  final String error;

  TypesErrorState(this.error);
}
