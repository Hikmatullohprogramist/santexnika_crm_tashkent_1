class Transfer2StoreModel {
  final int storeId;
  final int orderId;
  final double quantity;
  final String comment;

  Transfer2StoreModel({
    required this.storeId,
    required this.orderId,
    required this.quantity,
    required this.comment,
  });

  // Method to convert this object into a map. Useful for JSON encoding or sending data to APIs.
  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'order_id': orderId,
      'quantity': quantity,
      'comment': comment,
    };
  }

  // Factory constructor to create an Transfer2StoreModel instance from a map (JSON).
  factory Transfer2StoreModel.fromJson(Map<String, dynamic> json) {
    return Transfer2StoreModel(
      storeId: json['store_id'],
      orderId: json['order_id'],
      quantity: json['quantity'],
      comment: json['comment'],
    );
  }
}
