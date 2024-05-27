class Store {
  final String name;
  final String madeIn;
  final String quantity;
  final int count;

  Store({
    required this.name,
    required this.madeIn,
    required this.quantity,
    required this.count,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'] ?? '',
      madeIn: json['made_in'] ?? '',
      quantity: json['quantity'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class UserStores {
  final List<Store> storesMoreSelled;
  final List<Store> storesLessSelled;

  UserStores({
    required this.storesMoreSelled,
    required this.storesLessSelled,
  });

  factory UserStores.fromJson(Map<String, dynamic> json) {
    List<dynamic> moreSelledJson = json['stores_more_selled'];
    List<dynamic> lessSelledJson = json['stores_less_selled'];

    List<Store> moreSelled = moreSelledJson.map((storeJson) => Store.fromJson(storeJson)).toList();
    List<Store> lessSelled = lessSelledJson.map((storeJson) => Store.fromJson(storeJson)).toList();

    return UserStores(
      storesMoreSelled: moreSelled,
      storesLessSelled: lessSelled,
    );
  }
}
