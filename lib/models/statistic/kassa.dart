class KassaStatistic {
  final int id;
  final String name;
  final num kassaUzsNaqd;
  final num kassaUzsPlastik;
  final num kassaUzsClick;
  final num kassaUsd;
  final num sumSell;
  final num dollarSell;
  final num sumCome;
  final num dollarCome;

  KassaStatistic({
    required this.id,
    required this.name,
    required this.kassaUzsNaqd,
    required this.kassaUzsPlastik,
    required this.kassaUzsClick,
    required this.kassaUsd,
    required this.sumSell,
    required this.dollarSell,
    required this.sumCome,
    required this.dollarCome,
  });

  factory KassaStatistic.fromJson(Map<String, dynamic> json) {
    return KassaStatistic(
      id: json['id'] ,
      name: json['name'] ,
      kassaUzsNaqd: json['kassa_uzs_naqd'],
      kassaUzsPlastik: json['kassa_uzs_plastik'],
      kassaUzsClick: json['kassa_uzs_click'],
      kassaUsd: json['kassa_usd'],
      sumSell: json['sum_sell'],
      dollarSell: json['dollar_sell'] ,
      sumCome: json['sum_come'] ,
      dollarCome: json['dollar_come'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kassa_uzs_naqd': kassaUzsNaqd,
      'kassa_uzs_plastik': kassaUzsPlastik,
      'kassa_uzs_click': kassaUzsClick,
      'kassa_usd': kassaUsd,
      'sum_sell': sumSell,
      'dollar_sell': dollarSell,
      'sum_come': sumCome,
      'dollar_come': dollarCome,
    };
  }
}
