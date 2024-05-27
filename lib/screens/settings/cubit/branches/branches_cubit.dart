import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/models/branch/branch_model.dart';
import 'package:santexnika_crm/service/api_service/branch/branch.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final BranchService _branchService = BranchService();

  BranchesCubit() : super(BranchesInitial()) {
    getBranches();
  }

  Future<void> getBranches() async {
    emit(BranchesLoadingState());

    try {
      final Either<String, List<BranchModel>> dataa =
          await _branchService.getBranch();
      dataa.fold(
        (error) => emit(
          BranchesErrorState('error'),
        ),
        (data) {

          if(data.isEmpty) return emit(BranchesErrorState("Ma'lumotlar yo'q"));



          emit(

                BranchesSuccessState(data),
          );
        }
      );
    } catch (e) {
      emit(BranchesErrorState('error: $e'));
    }
  }

  Future<void> postBranches(String name, String barCode) async {
    emit(BranchesLoadingState());

    try {
      final Either<String, String> postData = await _branchService.postBranch(
        name,
        barCode,
      );
      postData.fold(
          (error) => emit(
                BranchesErrorState('error'),
              ), (data) {
        SnackBarWidget().showSnackbar("SUCCESS", data, 2, 4);
        getBranches();
      });
    } catch (e) {
      emit(
        BranchesErrorState('error'),
      );
    }
  }
}
