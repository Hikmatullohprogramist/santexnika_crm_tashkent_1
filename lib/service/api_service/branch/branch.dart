import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/models/branch/branch_model.dart';
import 'package:santexnika_crm/service/api_service/wrap_response.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

class BranchService {
  final Dio _dioConfig = DioConfig.getDio();

  /// Branch 🟢 🟢 🔴 🔴

  Future<Either<String, String>> postBranch(
    String name,
    String barCode,
  ) async {
    try {
      FormData formData = FormData.fromMap({'name': name, 'barcode': barCode});
      final response = await _dioConfig.post(
        'branch',
        data: formData,
      );

      if (response.statusCode == 201) {
        print('dataaa' + response.data["message"]);

        return right(response.data["message"]);
      } else {
        return left('Qoshishda xatolik');
      }
    } catch (e) {
      return left('Qoshishda xatolik');
    }
  }

  Future<Either<String, List<BranchModel>>> getBranch() async {
    try {
      final response = BaseResponseApi().wrapResponse(
        await _dioConfig.get('branches'),
        (data) => (data as List).map((e) => BranchModel.fromJson(e)).toList(),
      );
      if (response.data.isNotEmpty) {
        return right(response.data);
      } else {
        return left('Qandayqur xatolik bor');
      }
    } catch (e) {
      return left('error:$e');
    }
  }
}
