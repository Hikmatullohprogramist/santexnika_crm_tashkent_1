
class PriceModel {
  PriceModel({
      this.id, 
      this.name, 
      this.value, 
      this.createdAt, 
      this.updatedAt,});

  PriceModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['value'] = value;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}