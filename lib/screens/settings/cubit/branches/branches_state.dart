part of 'branches_cubit.dart';

@immutable
abstract class BranchesState {}

class BranchesInitial extends BranchesState {}

class BranchesLoadingState extends BranchesState {}

class BranchesSuccessState extends BranchesState {
  final List<BranchModel> data;

  BranchesSuccessState(this.data);
}

class BranchesErrorState extends BranchesState {
  final String error;

  BranchesErrorState(this.error);
}
