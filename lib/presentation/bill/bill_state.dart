import 'package:bill_n_stock/model/billIItemForwardModel.dart';
import 'package:bill_n_stock/model/inventory_model.dart';
import 'package:bill_n_stock/helper/pref.dart';
import 'package:flutter/material.dart';
import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/model/customer_data_model.dart';
import 'package:bill_n_stock/helper/Util.dart';

class BillState extends ChangeNotifier {
  bool isLoading = false;
  CustomerDataModel? customer;
  List<InventoryModel> items = [];
  final List<BillItem> billItems = [];

  Future<void> addCustomer({
    required String name,
    required String mobile,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();
    final user = await Pref.getUserModelValue(
      PreferenceKey.userData.toString(),
    );

    final params = {
      "userId": user.userId,
      "name": name,
      "contactNumber": mobile,
    };

    final result = await ApiServices.instance.makePostRequest(
      params,
      UrlEndPoint.addCustomerDetailsOrCheck,
      context,
    );

    isLoading = false;

    switch (result) {
      case Success(value: final data):
        customer = CustomerDataModel.fromJson(data["data"]);

        // 🔔 Show backend message (new or existing)
        Util.snackBarNew(data["responseMessage"]);

        await fetchInventory(context: context);

        notifyListeners();
        break;

      case Failure(exception: final e):
        Util.snackBarNew(e.toString());
        break;
    }
  }

  Future<void> fetchInventory({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await Pref.getUserModelValue(
        PreferenceKey.userData.toString(),
      );

      final result = await ApiServices.instance.makePathRequest(
        UrlEndPoint.inventoryItemList,
        "${user.userId}",
        context,
      );

      if (result is Success) {
        final List data = result.value["data"];

        items = data.map((e) => InventoryModel.fromJson(e)).toList();
      }
    } catch (e, stack) {
      debugPrint("❌ Inventory fetch error: $e");
      debugPrint(stack.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetCustomer() {
    customer = null;
    notifyListeners();
  }

  void addItemToBill(BillItem item) {
    // Replace if already exists
    billItems.removeWhere((e) => e.productId == item.productId);
    billItems.add(item);
    notifyListeners();
  }

  double get grandTotal => billItems.fold(0, (sum, item) => sum + item.total);

  void resetBill() {
    billItems.clear();
    notifyListeners();
  }
}
