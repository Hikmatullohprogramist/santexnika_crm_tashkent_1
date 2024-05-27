part of 'statistic_cubit.dart';

@immutable
abstract class StatisticState {}

class StatisticInitial extends StatisticState {}

class StatisticError extends StatisticState {
  final String error;

  StatisticError(this.error);
}

class StatisticLoading extends StatisticState {}

class StatisticSuccessStore extends StatisticState {
  final UserStores data;

  StatisticSuccessStore(this.data);
}

class StatisticSuccessCustomer extends StatisticState {
  final CustomersData data;

  StatisticSuccessCustomer(this.data);
}

class StatisticSuccessUsers extends StatisticState {
  final UsersData data;

  StatisticSuccessUsers(this.data);
}

class StatisticSuccessUsersReturned extends StatisticState {
  final UsersReturnedData data;

  StatisticSuccessUsersReturned(this.data);
}

class StatisticBranchesState extends StatisticState {
  final BranchStatistics data;

  StatisticBranchesState(this.data);
}

class StatisticTradeState extends StatisticState {
  final TradeStatisticModel data;

  StatisticTradeState(this.data);
}

class StatisticTradeAndStoreState extends StatisticState {
   final UserStores storeDate;  final List<KassaStatistic> data;


  StatisticTradeAndStoreState(   this.storeDate, this.data);
}

class StatisticKassaState extends StatisticState {
  final List<KassaStatistic> data;

  StatisticKassaState(this.data);
}
