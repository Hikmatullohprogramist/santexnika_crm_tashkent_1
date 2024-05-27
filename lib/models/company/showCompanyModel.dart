class ShowCompanyModel {
  final List<Data> data;
  final num debtsSum;
  final num debtsDollar;

  ShowCompanyModel({
    required this.data,
    required this.debtsSum,
    required this.debtsDollar,
  });

  factory ShowCompanyModel.fromJson(Map<String, dynamic> json) {
    return ShowCompanyModel(
      data: List<Data>.from(json['data'].map((item) => Data.fromJson(item))),
      debtsSum: json['debts_sum'],
      debtsDollar: json['debts_dollar'],
    );
  }
}

class Data {
  final int id;
  final int companyId;
  final int branchId;
  final int priceId;
  final int typeId;
  final String price;
  final String createdAt;
  final String updatedAt;
  final String? comment;
  final Branch branch;
  final Type type;
  final Company company;

  Data({
    required this.id,
    required this.companyId,
    required this.branchId,
    required this.priceId,
    required this.typeId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.comment,
    required this.branch,
    required this.type,
    required this.company,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      companyId: json['company_id'],
      branchId: json['branch_id'],
      priceId: json['price_id'],
      typeId: json['type_id'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      branch: Branch.fromJson(json['branch']),
      type: Type.fromJson(json['type']),
      company: Company.fromJson(json['company']),
      comment: json['comment'] ?? "N/A",
    );
  }
}

class Branch {
  final int id;
  final String name;
  final String? prefix;
  final String barcode;
  final int checkNumber;
  final String createdAt;
  final String updatedAt;

  Branch({
    required this.id,
    required this.name,
    this.prefix,
    required this.barcode,
    required this.checkNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      prefix: json['prefix'],
      barcode: json['barcode'],
      checkNumber: json['check_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Type {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  Type({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Company {
  final int id;
  final int branchId;
  final String name;
  final String phone;
  final dynamic debt;
  final String createdAt;
  final String updatedAt;

  Company({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phone,
    this.debt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      branchId: json['branch_id'],
      name: json['name'],
      phone: json['phone'],
      debt: json['debt'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
