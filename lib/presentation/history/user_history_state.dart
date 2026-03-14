import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/helper/pref.dart';
import 'package:bill_n_stock/model/user_history_model.dart';
import 'package:flutter/material.dart';

class UserHistoryState extends ChangeNotifier {
  final BuildContext context;

  bool isLoading = false;
  List<UserHistoryModel> items = [];

  UserHistoryState(this.context);

  Future<void> fetchInventory({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await Pref.getUserModelValue(
        PreferenceKey.userData.toString(),
      );

      final result = await ApiServices.instance.makePathRequest(
        UrlEndPoint.userHistory,
        "${user.userId}",
        context,
      );

      if (result is Success) {
        final List data = result.value["data"];

        items = data.map((e) => UserHistoryModel.fromJson(e)).toList();
      }
    } catch (e, stack) {
      debugPrint("❌ Inventory fetch error: $e");
      debugPrint(stack.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> payRemainingAmount({
    required int customerId,
    required double amount,
  }) async {
    final body = {"payAmount": amount};

    final result = await ApiServices.instance.makePutRequest(
      body,
      UrlEndPoint.customerEditApi,
      "$customerId",
      context,
    );

    if (result is Success) {
      Util.snackBarNew("Payment updated successfully");

      // Refresh list after payment
      await fetchInventory(context: context);
    } else if (result is Failure) {
      Util.snackBarNew("Error");
    }
  }
}
