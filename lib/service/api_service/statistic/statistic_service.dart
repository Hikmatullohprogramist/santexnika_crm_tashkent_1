import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:santexnika_crm/models/statistic/customer.dart';
import 'package:santexnika_crm/models/statistic/kassa.dart';
import 'package:santexnika_crm/models/statistic/store.dart';
import 'package:santexnika_crm/models/statistic/trade.dart';
import 'package:santexnika_crm/models/statistic/user.dart';
import 'package:santexnika_crm/models/statistic/user_returned.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

import '../../../models/statistic/branchs.dart';
import '../../../tools/format_date_time.dart';

class StatisticService {
  final Dio _dioConfig = DioConfig.getDio();

  Future<Either<String, UserStores>> storeStatistic() async {
    final response = await _dioConfig.get("statistics?type=stores");

    try {
      if (response.statusCode == 200) {
        return right(UserStores.fromJson(response.data));
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, List<KassaStatistic>>> kassaStatistic() async {
    final response = await _dioConfig.get("statistics/kassa");

    try {
      if (response.statusCode == 200) {
        return right((response.data["data"] as List)
            .map((e) => KassaStatistic.fromJson(e))
            .toList());
      } else {
        return left(response.statusMessage ?? "Xatolik!");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, CustomersData>> customersStatistic() async {
    final response = await _dioConfig.get("statistics?type=customers");

    try {
      if (response.statusCode == 200) {
        return right(CustomersData.fromJson(response.data));
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, UsersData>> usersStatistic() async {
    final response = await _dioConfig.get("statistics?type=users");

    try {
      if (response.statusCode == 200) {
        return right(UsersData.fromJson(response.data));
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, UsersReturnedData>> userReturnedStatistic() async {
    final response = await _dioConfig.get("statistics?type=users_returned");

    try {
      if (response.statusCode == 200) {
        return right(UsersReturnedData.fromJson(response.data));
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, BranchStatistics>> branches(
      String fromDate, String toDate) async {
    final response =
        await _dioConfig.get("statistics/branches/$fromDate/$toDate");

    try {
      if (response.statusCode == 200) {
        print(response.data);
        return right(BranchStatistics.fromJson(response.data));
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      print(e);
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, TradeStatisticModel>> trade(
      String fromDate, String toDate) async {
    final response = await _dioConfig.get("statistics/trade/$fromDate/$toDate");

    try {
      if (response.statusCode == 200) {
        print(response.data);
        return right(TradeStatisticModel.fromJson(response.data));
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      print(e);
    }

    return left("Qandaydur xatolik !");
  }

  Future<Either<String, Map<String, dynamic>>> fetchStatistics() async {

    const storeEndpoint = "statistics?type=stores";
    const kassaEndpoint = "statistics/kassa";

    try {
      final responses = await Future.wait([
         _dioConfig.get(storeEndpoint),
        _dioConfig.get(kassaEndpoint),
      ]);

       final storeResponse = responses[0];
      final kassaResponse = responses[1];

      if (kassaResponse.statusCode == 200 && storeResponse.statusCode == 200) {
         final storeData = UserStores.fromJson(storeResponse.data);
         List<KassaStatistic> kassaData = (kassaResponse.data["data"] as List).map((e) => KassaStatistic.fromJson(e)).toList();

        return right({
           'store': storeData,
          'kassa': kassaData,
        });
      } else {
        return left("Xatolik !");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return left("Qandaydur xatolik !");
    }
  }
}
