class ProductCalculation {
  num count;
  num calculateSum;
  num calculateDollar;
  num totalSum;
  num totalDollar;

  ProductCalculation({
    required this.count,
    required this.calculateSum,
    required this.calculateDollar,
    required this.totalSum,
    required this.totalDollar,
  });

   factory ProductCalculation.fromMap(Map<String, dynamic> data) {
    // Accessing data fields
    final calculateData = data['calculate'] ?? {};
    final totalData = data['total'] ?? {};

    return ProductCalculation(
      count: data['count'] ?? 0,
      calculateSum: calculateData['sum'] ?? 0,
      calculateDollar: calculateData['dollar'] ?? 0,
      totalSum: totalData['sum'] ?? 0,
      totalDollar: totalData['dollar'] ?? 0.0,
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'count': count,
      'calculate': {
        'sum': calculateSum,
        'dollar': calculateDollar,
      },
      'total': {
        'sum': totalSum,
        'dollar': totalDollar,
      },
    };
  }

  @override
  String toString() {
    return 'ProductCalculation(count: $count, calculateSum: $calculateSum, calculateDollar: $calculateDollar, totalSum: $totalSum, totalDollar: $totalDollar)';
  }
}
