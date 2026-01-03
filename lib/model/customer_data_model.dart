class CustomerDataModel {
  String? contactNumber;
  String? createdAt;
  int? id;
  String? name;

  CustomerDataModel({this.contactNumber, this.createdAt, this.id, this.name});

  CustomerDataModel.fromJson(Map<String, dynamic> json) {
    contactNumber = json['contactNumber'];
    createdAt = json['createdAt'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactNumber'] = this.contactNumber;
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
