class CategoryModel {
  CategoryModel({
      this.id, 
      this.branchId, 
      this.name, 
      this.createdAt, 
      this.updatedAt, 
      this.storesCount, 
      this.branch,});

  CategoryModel.fromJson(dynamic json) {
    id = json['id'];
    branchId = json['branch_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storesCount = json['stores_count'];
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
  }
  int? id;
  int? branchId;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? storesCount;
  Branch? branch;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['branch_id'] = branchId;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['stores_count'] = storesCount;
    if (branch != null) {
      map['branch'] = branch?.toJson();
    }
    return map;
  }

}

class Branch {
  Branch({
      this.id, 
      this.name, 
      this.prefix, 
      this.barcode, 
      this.checkNumber, 
      this.createdAt, 
      this.updatedAt,});

  Branch.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    prefix = json['prefix'];
    barcode = json['barcode'];
    checkNumber = json['check_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  dynamic prefix;
  String? barcode;
  int? checkNumber;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['prefix'] = prefix;
    map['barcode'] = barcode;
    map['check_number'] = checkNumber;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}