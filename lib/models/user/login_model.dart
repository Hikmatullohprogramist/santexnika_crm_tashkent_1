import 'package:santexnika_crm/models/user/usersModel.dart';

class LoginModel {
  final int id;
  final String name;
  final String phone;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int branchId;
  final String? role;
  final List<UserAccess> userAccess;
  final String token;

  LoginModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.branchId,
    required this.role,
    required this.userAccess,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    List<UserAccess> userAccessList = (json['user']['user_access'] as List)
        .map((access) => UserAccess.fromJson(access))
        .toList();

    return LoginModel(
      id: json['user']['id'],
      name: json['user']['name'],
      phone: json['user']['phone'],
      status: json['user']['status'],
      createdAt: DateTime.parse(json['user']['created_at']),
      updatedAt: DateTime.parse(json['user']['updated_at']),
      branchId: json['user']['branch_id'],
      role: json['user']['role'] ?? "",
      userAccess: userAccessList,
      token: json['token'],
    );
  }
}

class UserAccess {
  final int id;
  final int userId;
  final int accessId;
  final Access access;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAccess({
    required this.id,
    required this.userId,
    required this.accessId,
    required this.access,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAccess.fromJson(Map<String, dynamic> json) {
    return UserAccess(
      id: json['id'],
      userId: json['user_id'],
      accessId: json['access_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      access: Access.fromJson(json['access']),
    );
  }
}
