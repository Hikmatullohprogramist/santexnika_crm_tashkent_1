import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:santexnika_crm/models/statistic/customer.dart';
import 'package:santexnika_crm/models/statistic/kassa.dart';
import 'package:santexnika_crm/models/statistic/store.dart';
import 'package:santexnika_crm/models/statistic/trade.dart';
import 'package:santexnika_crm/models/statistic/user.dart';
import 'package:santexnika_crm/models/statistic/user_returned.dart';
import 'package:santexnika_crm/service/api_service/statistic/statistic_service.dart';

import '../../../models/statistic/branchs.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  StatisticCubit() : super(StatisticInitial());

  final StatisticService _service = StatisticService();

  getStoreStatistic() async {
    emit(StatisticLoading());
    Either<String, UserStores> data = await _service.storeStatistic();

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticSuccessStore(data));
      },
    );
  }

  getKassaStatistic() async {
    emit(StatisticLoading());
    Either<String, List<KassaStatistic>> data = await _service.kassaStatistic();

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticKassaState(data));
      },
    );
  }

  getCustomerStatistic() async {
    emit(StatisticLoading());
    Either<String, CustomersData> data = await _service.customersStatistic();

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticSuccessCustomer(data));
      },
    );
  }

  getUserStatistic() async {
    emit(StatisticLoading());
    Either<String, UsersData> data = await _service.usersStatistic();

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticSuccessUsers(data));
      },
    );
  }

  getUserReturnedStatistic() async {
    emit(StatisticLoading());
    Either<String, UsersReturnedData> data =
        await _service.userReturnedStatistic();

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticSuccessUsersReturned(data));
      },
    );
  }

  getBranchesStatistic(String fromDate, String toDate) async {
    emit(StatisticLoading());
    Either<String, BranchStatistics> data =
        await _service.branches(fromDate, toDate);

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticBranchesState(data));
      },
    );
  }

  getTradeStatistic(String fromDate, String toDate) async {
    emit(StatisticLoading());
    Either<String, TradeStatisticModel> data =
        await _service.trade(fromDate, toDate);

    data.fold(
      (error) {
        emit(StatisticError(error));
      },
      (data) {
        emit(StatisticTradeState(data));
      },
    );
  }

  void fetchAndHandleStatistics() async {
    Either<String, Map<String, dynamic>> data =
        await _service.fetchStatistics();

    data.fold(
      (error) => emit(StatisticError(error)),
      (data) {
         final storeData = data['store'] as UserStores;
        final kassaData = data['kassa'] as List<KassaStatistic>;

        emit(StatisticTradeAndStoreState( storeData, kassaData));
        // Use tradeData and storeData as needed
      },
    );
  }
}
