class UserBillModel {
  final int billId;
  final String billNumber;
  final double subtotal;
  final String discountType;
  final double discountValue;
  final double discountAmount;
  final double paidAmount;
  final double remainingAmount;
  final double finalAmount;
  final String createdAt;

  final List<UserBillItemModel> items;

  UserBillModel({
    required this.billId,
    required this.billNumber,
    required this.subtotal,
    required this.discountType,
    required this.discountValue,
    required this.discountAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.items,
  });

  factory UserBillModel.fromJson(Map<String, dynamic> json) {
    final billInfo = json['billInfo'];

    return UserBillModel(
      billId: billInfo['billId'],
      billNumber: billInfo['billNumber'],
      subtotal: (billInfo['subtotal'] as num).toDouble(),
      discountType: billInfo['discountType'],
      discountValue: (billInfo['discountValue'] as num).toDouble(),
      discountAmount: (billInfo['discountAmount'] as num).toDouble(),
      paidAmount: (billInfo['paidAmount'] as num).toDouble(),
      remainingAmount: (billInfo['remainingAmount'] as num).toDouble(),
      finalAmount: (billInfo['finalAmount'] as num).toDouble(),
      createdAt: billInfo['createdAt'],
      items: (json['items'] as List)
          .map((e) => UserBillItemModel.fromJson(e))
          .toList(),
    );
  }
}

class UserBillItemModel {
  final int productId;
  final String productName;
  final double quantityGram;
  final double pricePerGram;
  final double totalPrice;

  UserBillItemModel({
    required this.productId,
    required this.productName,
    required this.quantityGram,
    required this.pricePerGram,
    required this.totalPrice,
  });

  factory UserBillItemModel.fromJson(Map<String, dynamic> json) {
    return UserBillItemModel(
      productId: json['productId'],
      productName: json['productName'],
      quantityGram: (json['quantityGram'] as num).toDouble(),
      pricePerGram: (json['pricePerGram'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}
