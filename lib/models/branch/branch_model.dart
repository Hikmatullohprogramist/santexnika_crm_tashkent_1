class BranchModel {
  int? id;
  String? name;
  String? prefix;
  String? barcode;
  int? checkNumber;
  String? createdAt;
  String? updatedAt;

  BranchModel(
      {this.id,
      this.name,
      this.prefix,
      this.barcode,
      this.checkNumber,
      this.createdAt,
      this.updatedAt});

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    prefix = json['prefix'];
    barcode = json['barcode'];
    checkNumber = json['check_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['prefix'] = this.prefix;
    data['barcode'] = this.barcode;
    data['check_number'] = this.checkNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
