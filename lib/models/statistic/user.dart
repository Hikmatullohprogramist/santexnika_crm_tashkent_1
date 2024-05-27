class User {
  final String name;
  final int count;

  User({
    required this.name,
    required this.count,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class UserByPrice {
  final String name;
  final num? totalSum;
  final double? totalDollar;

  UserByPrice({
    required this.name,
    this.totalSum,
    this.totalDollar,
  });

  factory UserByPrice.fromJson(Map<String, dynamic> json) {
    return UserByPrice(
      name: json['name'] ?? '',
      totalSum: json['total_sum'],
      totalDollar: json['total_dollar']?.toDouble(),
    );
  }
}

class UsersData {
  final List<User> users;
  final List<UserByPrice> usersByPrice;

  UsersData({
    required this.users,
    required this.usersByPrice,
  });

  factory UsersData.fromJson(Map<String, dynamic> json) {
    List<dynamic> usersJson = json['users'];
    List<dynamic> usersByPriceJson = json['users_by_price'];

    List<User> users = usersJson.map((userJson) => User.fromJson(userJson)).toList();
    List<UserByPrice> usersByPrice = usersByPriceJson
        .map((userByPriceJson) => UserByPrice.fromJson(userByPriceJson))
        .toList();

    return UsersData(
      users: users,
      usersByPrice: usersByPrice,
    );
  }
}
