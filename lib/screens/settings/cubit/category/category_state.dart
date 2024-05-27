part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategorySuccessState extends CategoryState {
  final BaseModel<List<CategoryModel>> data;

  CategorySuccessState(this.data);
}

class CategoryErrorState extends CategoryState {
  final String error;

  CategoryErrorState(this.error);

}
