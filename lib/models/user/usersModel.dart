class UsersModel {
  UsersModel({
    this.id,
    this.name,
    this.phone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.branchId,
    this.role,
    this.userAccess,
  });

  UsersModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchId = json['branch_id'];
    role = json['role'];
    if (json['user_access'] != null) {
      userAccess = [];
      json['user_access'].forEach((v) {
        userAccess?.add(UserAccess.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  String? phone;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? branchId;
  String? role;
  List<UserAccess>? userAccess;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['branch_id'] = branchId;
    map['role'] = role;
    if (userAccess != null) {
      map['user_access'] = userAccess?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserAccess {
  UserAccess({
    this.id,
    this.userId,
    this.accessId,
    this.createdAt,
    this.updatedAt,
    this.access,
  });

  UserAccess.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    accessId = json['access_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    access = json['access'] != null ? Access.fromJson(json['access']) : null;
  }
  int? id;
  int? userId;
  int? accessId;
  String? createdAt;
  String? updatedAt;
  Access? access;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['access_id'] = accessId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (access != null) {
      map['access'] = access?.toJson();
    }
    return map;
  }
}

class Access {
  Access({
    this.id,
    this.name,
  });

  Access.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
