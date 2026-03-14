import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/helper/cell/toggle.dart';
import 'package:bill_n_stock/presentation/bill/billSummary/billSummaryScreen.dart';
import 'package:bill_n_stock/presentation/bill/billSummary/billSummary_state.dart';
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
    // Defining the theme colors locally for easy adjustment
    const Color primaryBlue = Color(0xFF2196F3);
    const Color lightBlueBg = Color(0xFFF0F7FF);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Create Bill',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<BillState>(
          builder: (_, state, __) {
            if (state.customer == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Customer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter customer details to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: nameController,
                    cursorColor: const Color(0xFF2196F3), // Blue cursor
                    style: const TextStyle(
                      color: Color(0xFF263238), // Dark text color
                    ),
                    decoration: InputDecoration(
                      hintText: 'Customer Name',
                      hintStyle: const TextStyle(
                        color: Color(0xFF78909C),
                      ), // Light blue-gray hint
                      filled: true,
                      fillColor: const Color(
                        0xFFF5FBFF,
                      ), // Very light blue background
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2196F3), // Blue border when focused
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFBBDEFB), // Light blue border
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    cursorColor: const Color(0xFF2196F3),
                    style: const TextStyle(color: Color(0xFF263238)),
                    decoration: InputDecoration(
                      counterText: '', // hides counter
                      hintText: 'Mobile Number',
                      hintStyle: const TextStyle(
                        color: Color(0xFF78909C),
                      ), // Light blue-gray hint
                      filled: true,
                      fillColor: const Color(
                        0xFFF5FBFF,
                      ), // Very light blue background
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2196F3), // Blue border when focused
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFBBDEFB), // Light blue border
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final mobile = mobileController.text.trim();
                        final billState = context.read<BillState>();

                        if (name.isEmpty || mobile.isEmpty) {
                          Util.snackBarNew('Please fill all details');
                          return;
                        }

                        if (name.length <= 3) {
                          Util.snackBarNew(
                            'Customer name must be more than 4 characters',
                          );
                          return;
                        }

                        if (mobile.length < 10) {
                          Util.snackBarNew(
                            'Mobile number must be at least 10 digits',
                          );
                          return;
                        }

                        billState.addCustomer(
                          name: name,
                          mobile: mobile,
                          context: context,
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Customer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            final customer = state.customer!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lightBlueBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE3F2FD),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Customer Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    customer.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  customer.contactNumber ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Change Button
                      IconButton(
                        onPressed: () {
                          context.read<BillState>().resetCustomer();
                        },
                        icon: const Icon(
                          Icons.swap_horiz_rounded,
                          size: 30,
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        splashRadius: 16,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Items Count
                Row(
                  children: [
                    Text(
                      'Available Items',
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
                        '${state.items.length} items',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔹 INVENTORY LIST
                Expanded(
                  child: state.items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_outlined,
                                size: 40,
                                color: primaryBlue.withOpacity(0.5),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No items available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return InventoryBillItem(item: item);
                          },
                        ),
                ),

                if (state.billItems.isNotEmpty) ...[
                  const SizedBox(height: 12),

                  // Added Items Summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primaryBlue, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Added Items (${state.billItems.length})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...state.billItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} (${item.quantity} ${item.unit})',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '₹${item.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Proceed Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Bill',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
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
    const Color primaryBlue = Color(0xFF2196F3);
    const Color lightBlueBg = Color(0xFFF8FBFF);

    final pricePerUnit = selectedUnit == 'Kg'
        ? widget.item.pricePerKg ?? 0
        : widget.item.pricePerGram ?? 0;

    final totalPrice = quantity * pricePerUnit;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3F2FD), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name and ID
          Row(
            children: [
              Expanded(
                child: Text(
                  (widget.item.productName ?? '').trim().replaceFirstMapped(
                    RegExp(r'^[a-zA-Z]'),
                    (m) => m.group(0)!.toUpperCase(),
                  ),

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹$pricePerUnit / $selectedUnit',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Row(
                    children: [
                      UnitToggle(
                        label: 'Kg',
                        selected: selectedUnit == 'Kg',
                        onTap: () {
                          setState(() {
                            selectedUnit = 'Kg';
                            quantity = 0;
                            qtyController.clear();
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                      UnitToggle(
                        label: 'Gm',
                        selected: selectedUnit == 'Gm',
                        onTap: () {
                          setState(() {
                            selectedUnit = 'Gm';
                            quantity = 0;
                            qtyController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Quantity Input and Add Button
          Row(
            children: [
              // Quantity Input
              SizedBox(
                width: 80,
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xFF2196F3), // Blue cursor
                  style: const TextStyle(
                    color: Color(0xFF263238), // Dark text color
                    fontSize: 13,
                  ),
                  onChanged: (value) {
                    setState(() {
                      quantity = double.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Qty',
                    hintStyle: const TextStyle(
                      color: Color(0xFF78909C),
                    ), // Light blue-gray hint
                    filled: true,
                    fillColor: const Color(
                      0xFFF5FBFF,
                    ), // Very light blue background
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3), // Blue border when focused
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFBBDEFB), // Light blue border
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Total Price
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Total: ₹${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Add Button
              SizedBox(
                height: 32,
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
