import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/pruduct/calculation_model.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/models/transfer_model.dart';
import 'package:santexnika_crm/tools/dio_configration.dart';

import '../../../models/base_model.dart';

class ProductService {
  final Dio _dioConfig = DioConfig.getDio();

  ///Product 🟢 🟢 🟢 🟢

  Future<Either<String, BaseModel<List<ProductModel>>>> getProduct(
      int page, String query) async {
    try {
      final response =
          await _dioConfig.get("products?page=$page&search=$query");
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ProductModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(getError + e.toString());
    }
  }

  Future<Either<String, ProductCalculation>> calculateProducts() async {
    try {
      final response = await _dioConfig.get("products/calculate");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(
          ProductCalculation.fromMap(response.data),
        );
      } else {
        return left(getError);
      }
    } catch (e) {
      return left(getError + e.toString());
    }
  }

  Future<Either<String, BaseModel<List<ProductModel>>>> searchProduct(
      String query, int page) async {
    try {
      final response =
          await _dioConfig.get('products?search=$query&page=$page');
      // final respionse = BaseResponseApi().wrapResponse(
      //     await _dioConfig.get('products?page=$page'), (data) => (data) {});
      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => ProductModel.fromJson(e)).toList(),
          ),
        );
      } else {
        return left(response.statusMessage ?? getError);
      }
    } catch (e) {
      return left(getError + e.toString());
    }
  }

  Future<Either<String, BaseModel<List<ProductModel>>>> postProduct(
    int categoryId,
    int branchId,
    int priceId,
    String name,
    String madeIn,
    String priceCome,
    String priceSell,
    String priceWholesale,
    String quantity,
    String dangerCount,
    dynamic productImage,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'category_id': categoryId,
        'branch_id': branchId,
        'price_id': priceId,
        'name': name,
        'made_in': madeIn,
        'price_come': priceCome,
        'price_sell': priceSell,
        'price_wholesale': priceWholesale,
        'quantity': quantity,
        'danger_count': dangerCount,
        if (productImage != null)
          'files': [
            await MultipartFile.fromFile(productImage.path,
                filename: 'productImage$name.png')
          ],
      });
      final response = await _dioConfig.post('product', data: formData);
      if (response.statusCode == 201) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ProductModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left(
          response.statusMessage ?? "Qandaydur xatolik qoshishda",
        );
      }
    } catch (e) {
      return left(postError);
    }
  }

  Future<Either<String, String>> addProduct(
    int storeId,
    double quantity,
  ) async {
    try {
      var data = {
        "storeId": storeId,
        "quantity": quantity,
      };
      final response = await _dioConfig.post(
        'product/add?store_id=$storeId&quantity=$quantity',
        data: data,
      );
      if (response.statusCode == 200) {
        return right(response.data["status"]);
      } else {
        return left(
          response.statusMessage ?? "Qandaydur xatolik qoshishda",
        );
      }
    } catch (e) {
      return left(postError);
    }
  }

  Future<Either<String, BaseModel<List<ProductModel>>>> deleteProduct(
      List<int> id) async {
    try {
      var data = json.encode({"stores": id});

      final response = await _dioConfig.delete('products/delete', data: data);

      if (response.statusCode == 200) {
        return right(BaseModel.fromJson(
            response.data,
            (data) =>
                (data as List).map((e) => ProductModel.fromJson(e)).toList()));
      } else {
        return left('Error: ${response.statusCode}');
      }
    } catch (e) {
      return left('Error: $e');
    }
  }

  Future<Either<String, BaseModel<List<ProductModel>>>> updateProduct(
    int id,
    int categoryId,
    int branchId,
    int priceId,
    String name,
    String madeIn,
    String priceCome,
    String priceSell,
    String priceWholesale,
    String quantity,
    String dangerCount,
    dynamic productImage,
  ) async {
    try {
      FormData formData = FormData();
      formData.fields.addAll([
        MapEntry('category_id', categoryId.toString()),
        MapEntry('branch_id', branchId.toString()),
        MapEntry('price_id', priceId.toString()),
        MapEntry('name', name),
        MapEntry('made_in', madeIn),
        MapEntry('price_come', priceCome),
        MapEntry('price_sell', priceSell),
        MapEntry('price_wholesale', priceWholesale),
        MapEntry('quantity', quantity),
        MapEntry('danger_count', dangerCount),
      ]);

      if (productImage != null && productImage.isNotEmpty) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            productImage.path,
            filename: 'productImage$name.png',
          ),
        ));
      }

      final response = await _dioConfig.post('product/$id', data: formData);

      if (response.statusCode == 200) {
        return right(
          BaseModel.fromJson(
            response.data,
            (data) => (data as List)
                .map(
                  (e) => ProductModel.fromJson(e),
                )
                .toList(),
          ),
        );
      } else {
        return left('error');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, BaseModel<List<ProductModel>>>> transfer2Branch(
      List<TransferModel> products) async {
    try {
      var data = json.encode({"products": products});

      final response = await _dioConfig.post('transfer', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(BaseModel.fromJson(
          response.data,
          (data) => (data as List)
              .map(
                (e) => ProductModel.fromJson(e),
              )
              .toList(),
        ));
      } else {
        return left("");
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
