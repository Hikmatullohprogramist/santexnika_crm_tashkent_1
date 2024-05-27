// ignore_for_file: deprecated_member_use
import 'package:dio/dio.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/tools/locator.dart';
import 'package:santexnika_crm/tools/prefs.dart';
import '../main.dart';
import 'handle_errors.dart';

class DioConfig {
  static Dio? _dio;

  static Dio getDio() {
    _dio ??= Dio()
      ..options = BaseOptions(
        baseUrl: AppConstants.BASE_URL,
        connectTimeout: const Duration(seconds: 60), // 60 seconds
        receiveTimeout: const Duration(seconds: 300), // 300 seconds
      )
      ..interceptors.add(dioRequestInspector.getDioRequestInterceptor())
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          // Update the 'Authorization' header with the latest token
          String token = await getIt<PrefUtils>().getToken();
           options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (DioError e, handler) {
          handler.next(e);
          HandleError().handleError(e);
        },
      ));
    return _dio!;
  }
}
