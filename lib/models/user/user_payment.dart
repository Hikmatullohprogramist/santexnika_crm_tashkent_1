class UserPayment {
  final bool success;
  final List<UserPaymentModel> data;
  final num all_sum;

  UserPayment({
    required this.success,
    required this.data,
    required this.all_sum,
  });

  factory UserPayment.fromJson(Map<String, dynamic> json) {
    List<UserPaymentModel> dataList = [];
    if (json['data'] != null) {
      var dataJsonList = json['data'] as List;
      dataList =
          dataJsonList.map((item) => UserPaymentModel.fromJson(item)).toList();
    }
    return UserPayment(
      success: json["success"],
      data: dataList,
      all_sum: json["all_sum"],
    );
  }
}

class UserPaymentModel {
  final int id;
  final int userId;
  final String price;
  final String comment;
  final String createdAt;
  final String updatedAt;

  UserPaymentModel({
    required this.id,
    required this.userId,
    required this.price,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
   });

  factory UserPaymentModel.fromJson(Map<String, dynamic> json) {
    return UserPaymentModel(
      id: json['id'],
      userId: json['user_id'],
      price: json['price'],
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
     );
  }
}
