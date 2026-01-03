class UserModel {
  int? userId;
  String? token;

  UserModel({this.userId, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['token'] = this.token;
    return data;
  }
}
