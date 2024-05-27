class TransferModel {
  TransferModel({
    required this.branchId,
    required this.storeId,
    required this.quantity,
  });
  late final int branchId;
  late final int storeId;
  late final int quantity;

  TransferModel.fromJson(Map<String, dynamic> json){
    branchId = json['branch_id'];
    storeId = json['store_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['branch_id'] = branchId;
    _data['store_id'] = storeId;
    _data['quantity'] = quantity;
    return _data;
  }
}