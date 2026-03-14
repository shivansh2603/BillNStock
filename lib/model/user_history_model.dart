class UserHistoryModel {
  int? customerId;
  int? userId;
  String? name;
  String? contactNumber;
  String? createdAt;

  double? paidAmount;
  double? remainingAmount;
  double? finalAmount;

  UserHistoryModel({
    this.customerId,
    this.userId,
    this.name,
    this.contactNumber,
    this.createdAt,
    this.paidAmount,
    this.remainingAmount,
    this.finalAmount,
  });

  UserHistoryModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    userId = json['userId'];
    name = json['name'];
    contactNumber = json['contactNumber'];
    createdAt = json['createdAt'];

    paidAmount = (json['paidAmount'] as num?)?.toDouble();
    remainingAmount = (json['remainingAmount'] as num?)?.toDouble();
    finalAmount = (json['finalAmount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'userId': userId,
      'name': name,
      'contactNumber': contactNumber,
      'createdAt': createdAt,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'finalAmount': finalAmount,
    };
  }
}
