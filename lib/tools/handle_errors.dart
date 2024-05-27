// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';

import 'locator.dart';
import 'prefs.dart';

class HandleError {
  handleError(dynamic e) {
    if (e.error is SocketException) {
      handleSocketException(e);
    } else {
      handleGeneralError(e);
    }
  }

  void handleSocketException(DioError e) {
    if (e.type == InternetAddressType.IPv4 ||
        e.type == InternetAddressType.IPv6) {
      SnackBarWidget()
          .showSnackbar("Internet", "Internetga ulanish yo'q", 6, 10);
    } else if (e.type == InternetAddressType.unix) {
      SnackBarWidget()
          .showSnackbar("XATOLIK", "Unix domain socket xatosi", 6, 10);
    } else if (e.message!.contains('Failed host lookup')) {
      SnackBarWidget().showSnackbar(
          "XATOLIK", "DNS muammo: Host izlash muvaffaqiyatsiz tugadi", 6, 10);
    } else if (e.message!.contains('Connection timed out')) {
      SnackBarWidget().showSnackbar(
          "Ulanish vaqti", "Ulanish vaqti tugadi. Qaytadan uruning", 6, 10);
    } else if (e.message!.contains('Connection refused')) {
      SnackBarWidget().showSnackbar("CONNECTION", "Ulanish rad etildi", 6, 10);
    } else if (e.message!.contains('Network is unreachable')) {
      SnackBarWidget()
          .showSnackbar("CONNECTION", "Tarmoqga ulanib bo'lmaydi", 6, 10);
    }
  }

  void handleGeneralError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectionTimeout:
        SnackBarWidget().showSnackbar(
            "Ulanish vaqti", "Ulanish vaqti tugadi: ${e.message}", 4, 4);
        break;
      case DioErrorType.receiveTimeout:
        SnackBarWidget().showSnackbar("Ma'lumotni qabul qilish",
            "Ma'lumotni qabul qilish vaqti tugadi: ${e.message}", 4, 4);
        break;
      case DioErrorType.badResponse:
        if (e.response!.statusCode == 401) {
          SnackBarWidget().showSnackbar("Token eskirgan", "Qayta kirish", 4, 4);
          getIt.get<PrefUtils>().clearAll();
        } else if (e.response!.statusCode == 400) {


          print("ERROR SHETGA KELYAPDI    ) ) )) ) ) )");
          SnackBarWidget().showSnackbar("Xatolik",
              e.response!.data["message"] ?? e.response!.data["error"], 4, 4);
        } else {
          SnackBarWidget().showSnackbar("Serverdan javob xatosi",
              "Serverdan javob xatosi: ${e.message}", 4, 4);
        }
        break;
      case DioErrorType.cancel:
        SnackBarWidget().showSnackbar(
            "Sorov bekor qilindi", "So'rov bekor qilindi: ${e.message}", 4, 4);
        break;
      case DioErrorType.unknown:
        SnackBarWidget()
            .showSnackbar("Umumiy xato", "Umumiy xato: ${e.message}", 4, 4);
        break;
      default:
        SnackBarWidget().showSnackbar(
            "Qandaydur xatolik", "Boshqa xato: ${e.message}", 4, 4);
        break;
    }
  }
}
