import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/taypes/taypes_model.dart';
import 'package:santexnika_crm/service/api_service/types/types.dart';

import '../../../../widgets/snek_bar_widget.dart';

part 'types_state.dart';

class TypesCubit extends Cubit<TypesState> {
  final TypesService typesService = TypesService();

  TypesCubit() : super(TypesInitial()) {
    getTypes();
  }

  Future<void> getTypes() async {
    emit(TypesLoadingState());

    try {
      final Either<String, List<TypesModel>> data =
          await typesService.getTypes();
      data.fold(
        (error) => emit(
          TypesErrorState('error'),
        ),
        (data) => emit(
          data.isNotEmpty ? TypesSuccessState(data) : TypesErrorState(empty),
        ),
      );
    } catch (e) {
      emit(TypesErrorState('error'));
    }
  }

  Future<void> postTypes(String name) async {
    emit(TypesLoadingState());

    try {
      final Either<String, List<TypesModel>> postData =
          await typesService.postTypes(name);
      postData.fold(
        (error) => emit(
          TypesErrorState(error),
        ),
        (data) {
          SnackBarWidget().showSnackbar("SUCCESS", "qo'shildi", 2, 4);
          getTypes();
        },
      );
    } catch (e) {
      emit(
        TypesErrorState(postError),
      );
    }
  }

  Future<void> updateType(int id, String name) async {
    emit(TypesLoadingState());

    try {
      final Either<String, List<TypesModel>> updateData =
          await typesService.updateTypes(id, name);
      updateData.fold(
        (error) => emit(TypesErrorState(error)),
        (data) => emit(
          TypesSuccessState(data),
        ),
      );
    } catch (e) {
      emit(
        TypesErrorState(
          e.toString(),
        ),
      );
    }
  }
}
