class InventoryModel {
  final String? createdAt;
  final int? id;
  final double? pricePerGram;
  final double? pricePerKg;
  final String? productName;
  final int? userId;

  InventoryModel({
    this.createdAt,
    this.id,
    this.pricePerGram,
    this.pricePerKg,
    this.productName,
    this.userId,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      createdAt: json['createdAt'],
      id: json['id'],
      pricePerGram: (json['pricePerGram'] as num?)?.toDouble(),
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble(),
      productName: json['productName'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'id': id,
      'pricePerGram': pricePerGram,
      'pricePerKg': pricePerKg,
      'productName': productName,
      'userId': userId,
    };
  }
}
