class CustomerModel {
  CustomerModel({
    this.id,
    this.branchId,
    this.name,
    this.phone,
    this.comment,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CustomerModel.fromJson(dynamic json) {
    id = json['id'];
    branchId = json['branch_id'];
    name = json['name'];
    phone = json['phone'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  int? branchId;
  String? name;
  String? phone;
  String? comment;
  int? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['branch_id'] = branchId;
    map['name'] = name;
    map['phone'] = phone;
    map['comment'] = comment;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
