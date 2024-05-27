class TradeStatisticModel {
  final String start;
  final String finish;
  final List<TradeItem> data;

  TradeStatisticModel({
    required this.start,
    required this.finish,
    required this.data,
  });

  factory TradeStatisticModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<TradeItem> saleItems =
        dataList.map((item) => TradeItem.fromJson(item)).toList();

    return TradeStatisticModel(
      start: json['start'],
      finish: json['finish'],
      data: saleItems,
    );
  }
}

class TradeItem {
  final int id;
  final String name;
  final double? sellPriceUZS;
  final double? sellPriceNAQD;
  final double? sellPricePlastik;
  final double? sellPriceClick;
  final double? sellPriceBackUZS;
  final double? sellPriceBackUSD;
  final double? sellPriceNasiyaUSD;
  final double? sellPriceNasiyaUZS;
  final double? customerPaymentUZS;
  final double? customerPaymentUSD;
  final double? toCompanyPaymentUSD;
  final double? toCompanyPaymentUZS;
  final double? kassaUZS;
  final double? kassaUSD;
  final double? sellPriceUSD;
  final double? expenceUZS;
  final double? expenceUSD;
  final double? vozvratUZS;
  final double? vozvratUSD;
  final double? benefituzs;
  final double? benefitUSD;
  final double? avarageDollar;
  final double? productPriceComeUZS;
  final double? productPriceComeUSD;

  TradeItem({
    required this.id,
    required this.name,
    this.sellPriceUZS,
    this.sellPriceNAQD,
    this.sellPricePlastik,
    this.sellPriceClick,
    this.sellPriceBackUZS,
    this.sellPriceBackUSD,
    this.sellPriceNasiyaUSD,
    this.sellPriceNasiyaUZS,
    this.customerPaymentUZS,
    this.customerPaymentUSD,
    this.toCompanyPaymentUSD,
    this.toCompanyPaymentUZS,
    this.kassaUZS,
    this.kassaUSD,
    this.sellPriceUSD,
    this.expenceUZS,
    this.expenceUSD,
    this.vozvratUZS,
    this.vozvratUSD,
    this.benefituzs,
    this.benefitUSD,
    this.avarageDollar,
    this.productPriceComeUZS,
    this.productPriceComeUSD,
  });

  factory TradeItem.fromJson(Map<String, dynamic> json) {
    return TradeItem(
      id: json['id'],
      name: json['name'],
      sellPriceUZS: json['sell_price_uzs']?.toDouble(),
      sellPriceNAQD: json['sell_price_naqd']?.toDouble(),
      sellPricePlastik: json['sell_price_plastik']?.toDouble(),
      sellPriceClick: json['sell_price_click']?.toDouble(),
      sellPriceBackUZS: json['sell_price_back_uzs']?.toDouble(),
      sellPriceBackUSD: json['sell_price_back_usd']?.toDouble(),
      sellPriceNasiyaUSD: json['sell_price_nasiya_usd']?.toDouble(),
      sellPriceNasiyaUZS: json['sell_price_nasiya_uzs']?.toDouble(),
      customerPaymentUZS: json['customer_payment_uzs']?.toDouble(),
      customerPaymentUSD: json['customer_payment_usd']?.toDouble(),
      toCompanyPaymentUSD: json['to_company_payment_usd']?.toDouble(),
      toCompanyPaymentUZS: json['to_company_payment_uzs']?.toDouble(),
      kassaUZS: json['kassa_uzs']?.toDouble(),
      kassaUSD: json['kassa_usd']?.toDouble(),
      sellPriceUSD: json['sell_price_usd']?.toDouble(),
      expenceUZS: json['expence_uzs']?.toDouble(),
      expenceUSD: json['expence_usd']?.toDouble(),
      vozvratUZS: json['vozvrat_uzs']?.toDouble(),
      vozvratUSD: json['vozvrat_usd']?.toDouble(),
      avarageDollar: json['dollarAverage']?.toDouble(),
      benefituzs: json.containsKey('conv_uzs') && json['conv_uzs'] != null
          ? json['conv_uzs']?.toDouble()
          : json['benefit_uzs']?.toDouble(),
      benefitUSD: json.containsKey('conv_usd') && json['conv_uzs'] != null
          ? json['conv_usd']?.toDouble()
          : json['benefit_usd']?.toDouble(),
      productPriceComeUZS:
          json.containsKey('price_come_uzs') && json['price_come_uzs'] != null
              ? json['price_come_uzs']?.toDouble()
              : 0,
      productPriceComeUSD:
          json.containsKey('price_come_usd') && json['price_come_usd'] != null
              ? json['price_come_usd']?.toDouble()
              : 0,
    );
  }
}
