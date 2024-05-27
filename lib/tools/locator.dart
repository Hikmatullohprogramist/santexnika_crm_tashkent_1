import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'prefs.dart';

final getIt = GetIt.instance;

Future<void> registerSingelton() async {
  final prefUtils = PrefUtils();

  await prefUtils.initInstane();

  getIt.registerSingleton(prefUtils);
  await provideApiService();

  if (kDebugMode) {
    print("Has been inited");
  }
}

Future<void> provideApiService() async {
  try {
    // await getIt.unregister<ApiService>();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  // final api = ApiService();
  // await api.addHeadrs();
  // getIt.registerSingleton(api);
}
