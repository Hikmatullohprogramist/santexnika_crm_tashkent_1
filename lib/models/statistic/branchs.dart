class BranchStatistics {
  final String start;
  final String finish;
  final List<SaleItem> data;

  BranchStatistics({
    required this.start,
    required this.finish,
    required this.data,
  });

  factory BranchStatistics.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<SaleItem> saleItems = dataList.map((item) => SaleItem.fromJson(item)).toList();

    return BranchStatistics(
      start: json['start'],
      finish: json['finish'],
      data: saleItems,
    );
  }
}

class SaleItem {
  final int id;
  final String name;
  final double? sellPriceUZS;
  final double? sellPriceUSD;
  final double? comePriceUZS;
  final double? comePriceUSD;

  SaleItem({
    required this.id,
    required this.name,
    this.sellPriceUZS,
    this.sellPriceUSD,
    this.comePriceUZS,
    this.comePriceUSD,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'],
      name: json['name'],
      sellPriceUZS: json['sell_price_uzs']?.toDouble(),
      sellPriceUSD: json['sell_price_usd']?.toDouble(),
      comePriceUZS: json['come_price_uzs']?.toDouble(),
      comePriceUSD: json['come_price_usd']?.toDouble(),
    );
  }
}
