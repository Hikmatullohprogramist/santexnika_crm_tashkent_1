class Calc {
  Calc({
    required this.uzs,
    required this.usd,
    required this.dollar,
  });
  late final num uzs;
  late final num usd;
  late final num dollar;

  Calc.fromJson(Map<String, dynamic> json) {
    uzs = json['uzs'];
    usd = json['usd'];
    dollar = json['dollar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uzs'] = uzs;
    _data['usd'] = usd;
    _data['dollar'] = usd;
    return _data;
  }
}
