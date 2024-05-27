import 'package:get/get.dart';
import 'package:santexnika_crm/screens/splash/splash.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  late SharedPreferences _singleton;

  SharedPreferences getInstanse() {
    return _singleton;
  }

  Future<bool> initInstane() async {
    _singleton = await SharedPreferences.getInstance();
    return true;
  }

  String getToken() {
    print(
        " HEADER TOKEN ========================== > ${_singleton.getString(AppConstants.ACCESS_TOKEN) ?? ""}");
    return _singleton.getString(AppConstants.ACCESS_TOKEN) ?? "";
  }

  Future<bool> setToken(String value) async {
    print(
        " NEW TOKEN  ========================== > ${value} NEW TOKEN  <==========================   ");

    return _singleton.setString(AppConstants.ACCESS_TOKEN, value);
  }

  // Future<void> saveListToPrefs(List<Device> models) async {
  //   List<String> encodedList =
  //       models.map((model) => jsonEncode(model.toJson())).toList();

  //   await _singleton.setStringList('deviceList', encodedList);
  // }

  // Future<List<Device>> getListFromPrefs() async {
  //   List<String>? encodedList = _singleton.getStringList('deviceList');
  //   if (encodedList == null) {
  //     return [];
  //   }
  //   return encodedList
  //       .map((encodedModel) => Device.fromJson(jsonDecode(encodedModel)))
  //       .toList();
  // }

  Future<void> clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    Get.offAll(const SplashScreen());
    return;
  }
}
