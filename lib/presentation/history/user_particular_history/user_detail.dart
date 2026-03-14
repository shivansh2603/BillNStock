import 'package:bill_n_stock/helper/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_detail_state.dart';
import 'package:bill_n_stock/model/bill_history.dart';

class UserDetailSingle extends StatelessWidget {
  const UserDetailSingle({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserDetailState>();
    const Color primaryBlue = Color(0xFF2196F3);
    const Color lightBlueBg = Color(0xFFF8FBFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'User Bills',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: state.bills.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE3F2FD)),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      size: 40,
                      color: primaryBlue.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No bills found',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No bills created for this customer',
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryBlue.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Header with count
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Bill History',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${state.bills.length} bills',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: state.bills.length,
                    itemBuilder: (context, index) {
                      // return _billCard(state.bills[index]);
                      return Column(
                        children: [
                          _billCard(state.bills[index]),
                          const SizedBox(height: 6),
                          Divider(height: 1, thickness: 1, color: Colors.black),
                          const SizedBox(height: 14),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _billCard(UserBillModel bill) {
    const Color primaryBlue = Color(0xFF2196F3);
    const Color lightBlueBg = Color(0xFFF8FBFF);
    final hasRemaining = bill.remainingAmount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3F2FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Bill Number
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasRemaining
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  hasRemaining ? "UNPAID" : "PAID",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: hasRemaining ? Colors.red : Colors.green,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bill.billNumber,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Amount Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE3F2FD)),
            ),
            child: Column(
              children: [
                _amountRow("Subtotal", bill.subtotal),
                const SizedBox(height: 6),
                _amountRow("Discount", bill.discountAmount),
                const SizedBox(height: 6),
                _amountRow("Paid", bill.paidAmount),
                const SizedBox(height: 6),
                _amountRow(
                  "Remaining",
                  bill.remainingAmount,
                  color: hasRemaining ? Colors.red : Colors.green,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE3F2FD)),
                  ),
                  child: _amountRow(
                    "Final Amount",
                    bill.finalAmount,
                    color: primaryBlue,
                    bold: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                "Created: ${bill.createdAt}",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Items Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Items (${bill.items.length})",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Items List
          ...bill.items.map(_itemRow).toList(),
        ],
      ),
    );
  }

  Widget _itemRow(UserBillItemModel item) {
    const Color primaryBlue = Color(0xFF2196F3);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3F2FD)),
      ),
      child: Row(
        children: [
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _itemDetail(
                      "Quantity",
                      Util.formatGramToKg(item.quantityGram),
                    ),
                    const SizedBox(width: 16),
                    _itemDetail("Rate", "₹${item.pricePerGram}/g"),
                  ],
                ),
              ],
            ),
          ),

          // Total Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "₹${item.totalPrice.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _amountRow(
    String label,
    double value, {
    Color? color,
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          "₹${value.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
