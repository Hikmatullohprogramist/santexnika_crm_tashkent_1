class Customer {
  final String name;
  final int count;

  Customer({
    required this.name,
    required this.count,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class CustomerByPrice {
  final String name;
  final int? totalSum;
  final int? totalDollar;

  CustomerByPrice({
    required this.name,
    this.totalSum,
    this.totalDollar,
  });

  factory CustomerByPrice.fromJson(Map<String, dynamic> json) {
    return CustomerByPrice(
      name: json['name'] ?? '',
      totalSum: json['total_sum'],
      totalDollar: json['total_dollar'],
    );
  }
}

class CustomersData {
  final List<Customer> customers;
  final List<CustomerByPrice> customersByPrice;

  CustomersData({
    required this.customers,
    required this.customersByPrice,
  });

  factory CustomersData.fromJson(Map<String, dynamic> json) {
    List<dynamic> customersJson = json['customers'];
    List<dynamic> customersByPriceJson = json['customers_by_price'];

    List<Customer> customers = customersJson.map((customerJson) => Customer.fromJson(customerJson)).toList();
    List<CustomerByPrice> customersByPrice = customersByPriceJson
        .map((customerByPriceJson) => CustomerByPrice.fromJson(customerByPriceJson))
        .toList();

    return CustomersData(
      customers: customers,
      customersByPrice: customersByPrice,
    );
  }
}
