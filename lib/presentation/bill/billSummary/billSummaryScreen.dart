import 'package:bill_n_stock/presentation/bill/billSummary/billSummary_state.dart';
import 'package:bill_n_stock/presentation/bill/bill_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillSummaryScreen extends StatelessWidget {
  final String customerName;
  final String customerMobile;
  final int customerId;

  const BillSummaryScreen({
    super.key,
    required this.customerName,
    required this.customerMobile,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    final billState = context.watch<BillState>();
    final summaryState = context.watch<BillsummaryState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Bill Summary')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                /// CUSTOMER INFO
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        customerMobile,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                /// ITEMS
                ...billState.billItems.map(
                  (item) => ListTile(
                    title: Text('${item.name} (ID: ${item.productId})'),
                    subtitle: Text(
                      '${item.quantity} ${item.unit} × ₹${item.pricePerUnit}',
                    ),
                    trailing: Text(
                      '₹ ${item.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// SUMMARY
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                _row('Total', billState.grandTotal),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: summaryState.discountType,
                  items: const [
                    DropdownMenuItem(value: 'PERCENT', child: Text('Percent')),
                    DropdownMenuItem(value: 'FLAT', child: Text('Flat')),
                  ],
                  onChanged: (v) =>
                      summaryState.changeDiscountType(v!, billState.grandTotal),
                  decoration: const InputDecoration(
                    labelText: 'Discount Type',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: summaryState.discountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) =>
                      summaryState.calculate(billState.grandTotal),
                  decoration: InputDecoration(
                    labelText: summaryState.discountType == 'PERCENT'
                        ? 'Discount %'
                        : 'Discount Amount',
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: summaryState.paidController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) =>
                      summaryState.calculate(billState.grandTotal),
                  decoration: const InputDecoration(
                    labelText: 'Paid Amount',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                _row('Final Amount', summaryState.finalAmount),
                _row(
                  'Remaining',
                  summaryState.remainingAmount,
                  color: summaryState.remainingAmount > 0
                      ? Colors.red
                      : Colors.green,
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: summaryState.isSaving
                        ? null
                        : () {
                            summaryState.saveBill(
                              context: context,
                              billState: billState,
                              customerId: customerId,
                            );
                          },
                    child: summaryState.isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Bill'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '₹ ${value.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
