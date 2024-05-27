class PriceTypeModel {
  PriceTypeModel({
    required this.id,
    required this.name,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String value;
  late final String createdAt;
  late final String updatedAt;

  PriceTypeModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['value'] = value;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}