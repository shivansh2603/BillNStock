import 'package:bill_n_stock/model/inventory_model.dart';
import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/helper/pref.dart';
import 'package:flutter/material.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';

class InventoryState extends ChangeNotifier {
  bool isLoading = false;
  List<InventoryModel> items = [];

  /// 🔹 ADD INVENTORY ITEM
  Future<bool> addInventoryItem({
    required String productName,
    required double pricePerKg,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    final user = await Pref.getUserModelValue(
      PreferenceKey.userData.toString(),
    );

    final params = {
      "userId": user.userId,
      "productName": productName,
      "pricePerKg": pricePerKg,
    };

    final result = await ApiServices.instance.makePostRequest(
      params,
      UrlEndPoint.saveInventoryItem,
      context,
    );

    isLoading = false;

    if (result is Success) {
      // Optional: refresh list after adding
      await fetchInventory(context: context);
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
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

  Future<bool> updateProductPrice({
    required int productId,
    required double pricePerKg,
    required BuildContext context,
  }) async {
    final body = {"pricePerKg": pricePerKg};

    final result = await ApiServices.instance.makePutRequest(
      body,
      UrlEndPoint.updateProductPrice,
      "$productId", // 👈 THIS is the `1`
      context,
    );

    if (result is Success) {
      await fetchInventory(context: context);
      return true;
    } else if (result is Failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("result.error.message")));
    }
    return false;
  }
}
