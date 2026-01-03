import 'package:bill_n_stock/home/bill/billSummary/billSummaryScreen.dart';
import 'package:bill_n_stock/home/bill/billSummary/billSummary_state.dart';
import 'package:bill_n_stock/model/billIItemForwardModel.dart';
import 'package:bill_n_stock/model/inventory_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bill_state.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Create Bill', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<BillState>(
          builder: (_, state, __) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.customer == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            mobileController.text.isEmpty) {
                          return;
                        }

                        context.read<BillState>().addCustomer(
                          name: nameController.text.trim(),
                          mobile: mobileController.text.trim(),
                          context: context,
                        );
                      },
                      child: const Text('Add Customer'),
                    ),
                  ),
                ],
              );
            }

            /// ✅ CUSTOMER DISPLAY (NEW OR EXISTING)
            final customer = state.customer!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 CUSTOMER CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        customer.contactNumber ?? '',
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Customer ID: ${customer.id}',
                        style: const TextStyle(color: Colors.black45),
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () {
                          context.read<BillState>().resetCustomer();
                        },
                        child: const Text('Change Customer'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),

                // 🔹 INVENTORY LIST
                Expanded(
                  child: state.items.isEmpty
                      ? const Center(
                          child: Text(
                            'No items available',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.separated(
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return InventoryBillItem(item: item);
                          },
                        ),
                ),
                if (state.billItems.isNotEmpty) ...[
                  const SizedBox(height: 8),

                  /// 🔹 ADDED ITEMS PREVIEW
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Added Items',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ...state.billItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} (${item.quantity} ${item.unit})',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₹ ${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 🔹 PROCEED BUTTON
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(
                                    value: context.read<BillState>(),
                                  ),
                                  ChangeNotifierProvider(
                                    create: (_) => BillsummaryState(),
                                  ),
                                ],
                                child: BillSummaryScreen(
                                  customerName: customer.name ?? '',
                                  customerMobile: customer.contactNumber ?? '',
                                  customerId: customer.id!,
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('Proceed to Bill'),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class InventoryBillItem extends StatefulWidget {
  final InventoryModel item;

  const InventoryBillItem({super.key, required this.item});

  @override
  State<InventoryBillItem> createState() => _InventoryBillItemState();
}

class _InventoryBillItemState extends State<InventoryBillItem> {
  String selectedUnit = 'Kg';
  final TextEditingController qtyController = TextEditingController();

  double quantity = 0;

  @override
  Widget build(BuildContext context) {
    final pricePerUnit = selectedUnit == 'Kg'
        ? widget.item.pricePerKg ?? 0
        : widget.item.pricePerGram ?? 0;

    final totalPrice = quantity * pricePerUnit;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 NAME + UNIT DROPDOWN
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.item.productName} (ID: ${widget.item.id})',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              DropdownButton<String>(
                value: selectedUnit,
                items: const [
                  DropdownMenuItem(value: 'Kg', child: Text('Kg')),
                  DropdownMenuItem(value: 'Gm', child: Text('Gm')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedUnit = value;
                    quantity = 0;
                    qtyController.clear();
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 PRICE PER UNIT
          Text(
            '₹ $pricePerUnit / $selectedUnit',
            style: const TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 10),

          /// 🔹 QUANTITY + TOTAL + ADD
          Row(
            children: [
              /// Quantity input
              Expanded(
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      quantity = double.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: selectedUnit == 'Kg' ? 'Enter Kg' : 'Enter Gm',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Total price
              Text(
                '₹ ${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),

              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: quantity <= 0
                    ? null
                    : () {
                        final billItem = BillItem(
                          productId: widget.item.id!,
                          name: widget.item.productName ?? '',
                          unit: selectedUnit,
                          quantity: quantity,
                          pricePerUnit: pricePerUnit,
                          total: totalPrice,
                        );

                        context.read<BillState>().addItemToBill(billItem);

                        qtyController.clear();
                        setState(() {
                          quantity = 0;
                        });
                      },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
