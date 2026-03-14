import 'package:bill_n_stock/model/bill_history.dart';
import 'package:flutter/material.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/api/ApiManager.dart';

class UserDetailState extends ChangeNotifier {
  final BuildContext context;
  final int customerId;

  bool isLoading = false;
  List<UserBillModel> bills = [];

  UserDetailState(this.context, {required this.customerId});

  Future<void> fetchCustomerDetails() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await ApiServices.instance.makePathRequest(
        UrlEndPoint.userDetailSimple,
        "$customerId",
        context,
      );

      if (result is Success) {
        bills = (result.value['data']['bills'] as List)
            .map((e) => UserBillModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("❌ Customer detail error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
