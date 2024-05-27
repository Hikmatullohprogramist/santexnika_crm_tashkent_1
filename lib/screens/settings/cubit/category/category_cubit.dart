import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/service/api_service/category/category.dart';

import '../../../../errors/service_error.dart';
import '../../../../models/categories/CategoryModel.dart';
import '../../../../widgets/snek_bar_widget.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService categoryService = CategoryService();

  CategoryCubit() : super(CategoryInitial()) {
    getCategory(0);
  }

  Future<void> getCategory(int page) async {
    emit(
      CategoryLoadingState(),
    );

    try {
      final Either<String, BaseModel<List<CategoryModel>>> dataa =
          await categoryService.getCategory(page);
      dataa.fold(
        (error) => emit(
          CategoryErrorState(error),
        ),
        (data) => data.data.isNotEmpty
            ? emit(
                CategorySuccessState(data),
              )
            : emit(
                CategoryErrorState("Malumotlar yoq"),
              ),
      );
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }

  Future<void> postCategory(String name, String branchId) async {
    emit(CategoryLoadingState());

    try {
      final Either<String, String> postData =
          await categoryService.postCategory(name, branchId);
      postData.fold(
        (error) => emit(
          CategoryErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar('SUCCESS', data, 2, 4);
          getCategory(0);
        },
      );
    } catch (e) {
      emit(CategoryErrorState(postError));
    }
  }

  Future<void> updateCategory(
      String name, String branchId, int categoryId) async {
    emit(CategoryLoadingState());

    try {
      final Either<String, String> updateData =
          await categoryService.updateCategory(name, branchId, categoryId);
      updateData.fold(
        (error) => emit(
          CategoryErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar('SUCCESS', data, 2, 4);
          getCategory(0);
        },
      );
    } catch (e) {
      emit(CategoryErrorState(postError));
    }
  }

  Future<void> deleteCategory(int id) async {
    emit(CategoryLoadingState());
    try {
      final Either<String, BaseModel<List<CategoryModel>>> deleteData =
          await categoryService.deleteCategory(id);
      deleteData.fold(
        (l) {
          emit(
            CategoryErrorState(l),
          );
          getCategory(0);
        },
        (data) => emit(
          CategorySuccessState(data),
        ),
      );
    } catch (e) {
      return emit(CategoryErrorState(e.toString()));
    }
  }
}
