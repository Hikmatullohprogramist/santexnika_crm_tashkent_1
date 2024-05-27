
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SnackBarWidget {
  showSnackbar(
      String title, String message, int duration, int animationDuration) {
    return Get.showSnackbar(
      GetSnackBar(
        title: title,
        showProgressIndicator: true,
        snackPosition: SnackPosition.TOP,
        message: message,
        animationDuration: Duration(milliseconds: animationDuration),
        isDismissible: true,
        duration: Duration(seconds: duration),
      ),
    );
  }
}

