import 'dart:convert';
import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/home/bill/bill_state.dart';
import 'package:bill_n_stock/home/home_screen.dart';
import 'package:flutter/material.dart';

class BillsummaryState extends ChangeNotifier {
  String discountType = 'PERCENT';

  final TextEditingController discountController = TextEditingController();
  final TextEditingController paidController = TextEditingController();

  double discountAmount = 0;
  double finalAmount = 0;
  double remainingAmount = 0;

  bool isSaving = false;

  Future<void> saveBill({
    required BuildContext context,
    required BillState billState,
    required int customerId,
  }) async {
    isSaving = true;
    notifyListeners();

    try {
      final double discountValue =
          double.tryParse(discountController.text) ?? 0;

      final double paidAmount = double.tryParse(paidController.text) ?? 0;

      /// ITEMS PAYLOAD
      final itemsPayload = billState.billItems.map((item) {
        final double quantityGram = item.unit == 'Kg'
            ? item.quantity * 1000
            : item.quantity;

        final double pricePerGram = item.unit == 'Kg'
            ? item.pricePerUnit / 1000
            : item.pricePerUnit;

        return {
          "product": {"id": item.productId},
          "quantityGram": quantityGram,
          "pricePerGram": pricePerGram,
          "totalPrice": item.total,
        };
      }).toList();

      /// FINAL PAYLOAD (MATCH BACKEND)
      final payload = {
        "bill": {
          "customer": {"id": customerId},
          "subtotal": billState.grandTotal,
          "discountType": discountType,
          "discountValue": discountValue,
          "discountAmount": discountAmount,
          "finalAmount": finalAmount,
          "paidAmount": paidAmount,
          "remainingAmount": remainingAmount,
        },
        "items": itemsPayload,
      };

      debugPrint("📦 SAVE BILL PAYLOAD → ${jsonEncode(payload)}");

      final result = await ApiServices.instance.makePostRequest(
        payload,
        UrlEndPoint.saveBill,
        context,
      );

      if (result is Success) {
        debugPrint("✅ BILL SAVED SUCCESSFULLY");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        Util.snackBarNew("BILL SAVED SUCCESSFULLY");
      } else if (result is Failure) {
        debugPrint("❌ BILL SAVE FAILED: ");
      }
    } catch (e, stack) {
      debugPrint("❌ Save bill error: $e");
      debugPrint(stack.toString());
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  void calculate(double grandTotal) {
    final discountValue = double.tryParse(discountController.text) ?? 0;
    final paidAmount = double.tryParse(paidController.text) ?? 0;

    if (discountType == 'PERCENT') {
      discountAmount = grandTotal * discountValue / 100;
    } else {
      discountAmount = discountValue;
    }

    finalAmount = (grandTotal - discountAmount).clamp(0, double.infinity);
    remainingAmount = (finalAmount - paidAmount).clamp(0, double.infinity);

    notifyListeners();
  }

  void changeDiscountType(String value, double grandTotal) {
    discountType = value;
    discountController.clear();
    calculate(grandTotal);
  }

  void disposeControllers() {
    discountController.dispose();
    paidController.dispose();
  }
}
