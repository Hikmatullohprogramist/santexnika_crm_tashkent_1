class CustomerWithId {
  List<Data>? _data;
  Debts? _debts;

  CustomerWithId({List<Data>? data, Debts? debts}) {
    if (data != null) {
      _data = data;
    }
    if (debts != null) {
      _debts = debts;
    }
  }

  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;
  Debts? get debts => _debts;
  set debts(Debts? debts) => _debts = debts;

  CustomerWithId.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
    _debts = json['debts'] != null ? new Debts.fromJson(json['debts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    if (_debts != null) {
      data['debts'] = _debts!.toJson();
    }
    return data;
  }
}

class Data {
  int? _id;
  int? _branchId;
  int? _customerId;
  int? _typeId;
  int? _priceId;
  String? _price;
  String? _comment;
  String? _createdAt;
  String? _updatedAt;
  Branch? _branch;
  Type? _type;
  Customer? _customer;

  Data(
      {int? id,
      int? branchId,
      int? customerId,
      int? typeId,
      int? priceId,
      String? price,
      String? comment,
      String? createdAt,
      String? updatedAt,
      Branch? branch,
      Type? type,
      Customer? customer}) {
    if (id != null) {
      _id = id;
    }
    if (branchId != null) {
      _branchId = branchId;
    }
    if (customerId != null) {
      _customerId = customerId;
    }
    if (typeId != null) {
      _typeId = typeId;
    }
    if (priceId != null) {
      _priceId = priceId;
    }
    if (price != null) {
      _price = price;
    }
    if (comment != null) {
      _comment = comment;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (branch != null) {
      _branch = branch;
    }
    if (type != null) {
      _type = type;
    }
    if (customer != null) {
      _customer = customer;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get branchId => _branchId;
  set branchId(int? branchId) => _branchId = branchId;
  int? get customerId => _customerId;
  set customerId(int? customerId) => _customerId = customerId;
  int? get typeId => _typeId;
  set typeId(int? typeId) => _typeId = typeId;
  int? get priceId => _priceId;
  set priceId(int? priceId) => _priceId = priceId;
  String? get price => _price;
  set price(String? price) => _price = price;
  String? get comment => _comment;
  set comment(String? comment) => _comment = comment;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  Branch? get branch => _branch;
  set branch(Branch? branch) => _branch = branch;
  Type? get type => _type;
  set type(Type? type) => _type = type;
  Customer? get customer => _customer;
  set customer(Customer? customer) => _customer = customer;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _branchId = json['branch_id'];
    _customerId = json['customer_id'];
    _typeId = json['type_id'];
    _priceId = json['price_id'];
    _price = json['price'];
    _comment = json['comment'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _branch =
        json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
    _type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    _customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['branch_id'] = _branchId;
    data['customer_id'] = _customerId;
    data['type_id'] = _typeId;
    data['price_id'] = _priceId;
    data['price'] = _price;
    data['comment'] = _comment;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_branch != null) {
      data['branch'] = _branch!.toJson();
    }
    if (_type != null) {
      data['type'] = _type!.toJson();
    }
    if (_customer != null) {
      data['customer'] = _customer!.toJson();
    }
    return data;
  }
}

class Branch {
  int? _id;
  String? _name;
  String? _prefix;
  String? _barcode;
  int? _checkNumber;
  String? _createdAt;
  String? _updatedAt;

  Branch(
      {int? id,
      String? name,
      String? prefix,
      String? barcode,
      int? checkNumber,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (prefix != null) {
      _prefix = prefix;
    }
    if (barcode != null) {
      _barcode = barcode;
    }
    if (checkNumber != null) {
      _checkNumber = checkNumber;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get prefix => _prefix;
  set prefix(String? prefix) => _prefix = prefix;
  String? get barcode => _barcode;
  set barcode(String? barcode) => _barcode = barcode;
  int? get checkNumber => _checkNumber;
  set checkNumber(int? checkNumber) => _checkNumber = checkNumber;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Branch.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _prefix = json['prefix'];
    _barcode = json['barcode'];
    _checkNumber = json['check_number'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['prefix'] = _prefix;
    data['barcode'] = _barcode;
    data['check_number'] = _checkNumber;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class Type {
  int? _id;
  String? _name;
  String? _createdAt;
  String? _updatedAt;

  Type({int? id, String? name, String? createdAt, String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Type.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class Customer {
  int? _id;
  int? _branchId;
  String? _name;
  String? _phone;
  String? _comment;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  Customer(
      {int? id,
      int? branchId,
      String? name,
      String? phone,
      String? comment,
      int? status,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (branchId != null) {
      _branchId = branchId;
    }
    if (name != null) {
      _name = name;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (comment != null) {
      _comment = comment;
    }
    if (status != null) {
      _status = status;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get branchId => _branchId;
  set branchId(int? branchId) => _branchId = branchId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get comment => _comment;
  set comment(String? comment) => _comment = comment;
  int? get status => _status;
  set status(int? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Customer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _branchId = json['branch_id'];
    _name = json['name'];
    _phone = json['phone'];
    _comment = json['comment'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['branch_id'] = _branchId;
    data['name'] = _name;
    data['phone'] = _phone;
    data['comment'] = _comment;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class Debts {
  num? _allDollar;
  num? _allSum;

  Debts({double? allDollar, int? allSum}) {
    if (allDollar != null) {
      _allDollar = allDollar;
    }
    if (allSum != null) {
      _allSum = allSum;
    }
  }

  num? get allDollar => _allDollar;
  set allDollar(num? allDollar) => _allDollar = allDollar;
  num? get allSum => _allSum;
  set allSum(num? allSum) => _allSum = allSum;

  Debts.fromJson(Map<String, dynamic> json) {
    if (json['all_dollar'] is int) {
      _allDollar = (json['all_dollar'] as int).toDouble();
    } else {
      _allDollar = json['all_dollar'] as double?;
    }
    _allSum = json['all_sum'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_dollar'] = _allDollar;
    data['all_sum'] = _allSum;
    return data;
  }
}
