class UserReturned {
  final String name;
  final num? count;

  UserReturned({
    required this.name,
    required this.count,
  });

  factory UserReturned.fromJson(Map<String, dynamic> json) {
    return UserReturned(
      name: json['name'] ?? '',
      count: json['count'],
    );
  }
}

class UserReturnedByPrice {
  final String name;
  final num? totalSum;
  final num? totalDollar;

  UserReturnedByPrice({
    required this.name,
    this.totalSum,
    this.totalDollar,
  });

  factory UserReturnedByPrice.fromJson(Map<String, dynamic> json) {
    return UserReturnedByPrice(
      name: json['name'] ?? '',
      totalSum: json['total_sum'],
      totalDollar: json['total_dollar'],
    );
  }
}

class UsersReturnedData {
  final List<UserReturned> usersReturned;
  final List<UserReturnedByPrice> usersReturnedByPrice;

  UsersReturnedData({
    required this.usersReturned,
    required this.usersReturnedByPrice,
  });

  factory UsersReturnedData.fromJson(Map<String, dynamic> json) {
    List<dynamic> usersReturnedJson = json['users_returned'];
    List<dynamic> usersReturnedByPriceJson = json['users_returned_by_price'];

    List<UserReturned> usersReturned = usersReturnedJson
        .map((userReturnedJson) => UserReturned.fromJson(userReturnedJson))
        .toList();
    List<UserReturnedByPrice> usersReturnedByPrice = usersReturnedByPriceJson
        .map((userReturnedByPriceJson) =>
            UserReturnedByPrice.fromJson(userReturnedByPriceJson))
        .toList();

    return UsersReturnedData(
      usersReturned: usersReturned,
      usersReturnedByPrice: usersReturnedByPrice,
    );
  }
}
