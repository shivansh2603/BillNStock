import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/helper/cell/toggle.dart';
import 'package:bill_n_stock/presentation/inventory/inventory_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryState>().fetchInventory(context: context);
    });
  }

  // void _openAddItemDialog() {
  //   final parentContext = context;
  //   final TextEditingController nameController = TextEditingController();
  //   final TextEditingController qtyController = TextEditingController();
  //   const Color primaryBlue = Color(0xFF2196F3);
  //   const Color lightBlueBg = Color(0xFFF8FBFF);
  //   String selectedUnit = 'Kg';

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           AlertDialog(
  //             backgroundColor: Colors.white,
  //             title: Container(
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: lightBlueBg,
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(16),
  //                   topRight: Radius.circular(16),
  //                 ),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: primaryBlue,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: const Icon(
  //                       Icons.add_circle_outline,
  //                       color: Colors.white,
  //                       size: 20,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   const Text(
  //                     'Add New Item',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             content: Container(
  //               color: Colors.white,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const SizedBox(height: 8),
  //                   // Item Name
  // TextField(
  //   controller: nameController,
  //   cursorColor: primaryBlue,
  //   style: const TextStyle(fontSize: 14),
  //   decoration: InputDecoration(
  //     hintText: 'Item Name',
  //     hintStyle: const TextStyle(
  //       fontSize: 13,
  //       color: Color(0xFF78909C),
  //     ),
  //     filled: true,
  //     fillColor: lightBlueBg,
  //     contentPadding: const EdgeInsets.symmetric(
  //       horizontal: 14,
  //       vertical: 12,
  //     ),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: BorderSide.none,
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: const BorderSide(
  //         color: Color(0xFF2196F3),
  //         width: 1.5,
  //       ),
  //     ),
  //   ),
  // ),

  //                   const SizedBox(height: 12),

  //                   // // Unit Dropdown
  //                   // Container(
  //                   //   decoration: BoxDecoration(
  //                   //     color: lightBlueBg,
  //                   //     borderRadius: BorderRadius.circular(10),
  //                   //   ),
  //                   //   child: DropdownButtonFormField<String>(
  //                   //     value: selectedUnit,
  //                   //     dropdownColor: Colors.white,
  //                   //     style: const TextStyle(fontSize: 14, color: Colors.black87),
  //                   //     decoration: InputDecoration(
  //                   //       filled: true,
  //                   //       fillColor: lightBlueBg,
  //                   //       contentPadding: const EdgeInsets.symmetric(
  //                   //         horizontal: 14,
  //                   //         vertical: 12,
  //                   //       ),
  //                   //       border: OutlineInputBorder(
  //                   //         borderRadius: BorderRadius.circular(10),
  //                   //         borderSide: BorderSide.none,
  //                   //       ),
  //                   //       focusedBorder: OutlineInputBorder(
  //                   //         borderRadius: BorderRadius.circular(10),
  //                   //         borderSide: const BorderSide(
  //                   //           color: Color(0xFF2196F3),
  //                   //           width: 1.5,
  //                   //         ),
  //                   //       ),
  //                   //     ),
  //                   //     items: const [
  //                   //       DropdownMenuItem(value: 'Kg', child: Text('Kg')),
  //                   //       DropdownMenuItem(value: '100 Gm', child: Text('100 Gm')),
  //                   //     ],
  //                   //     onChanged: (value) {
  //                   //       selectedUnit = value!;
  //                   //     },
  //                   //   ),
  //                   // ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       UnitToggle(
  //                         label: 'Kg',
  //                         selected: selectedUnit == 'Kg',
  //                         onTap: () {
  //                           setDialogState(() {
  //                             selectedUnit = 'Kg';
  //                           });
  //                         },
  //                       ),
  //                       const SizedBox(width: 8),
  //                       UnitToggle(
  //                         label: '100 Gm', // 👈 ONLY TEXT CHANGE
  //                         selected: selectedUnit == '100 Gm',
  //                         onTap: () {
  //                           setDialogState(() {
  //                             selectedUnit = '100 Gm';
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),

  //                   const SizedBox(height: 12),

  //                   // Price
  // TextField(
  //   controller: qtyController,
  //   keyboardType: TextInputType.number,
  //   cursorColor: primaryBlue,
  //   style: const TextStyle(fontSize: 14),
  //   decoration: InputDecoration(
  //     hintText: 'Price per unit',
  //     hintStyle: const TextStyle(
  //       fontSize: 13,
  //       color: Color(0xFF78909C),
  //     ),
  //     filled: true,
  //     fillColor: lightBlueBg,
  //     contentPadding: const EdgeInsets.symmetric(
  //       horizontal: 14,
  //       vertical: 12,
  //     ),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: BorderSide.none,
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: const BorderSide(
  //         color: Color(0xFF2196F3),
  //         width: 1.5,
  //       ),
  //     ),
  //   ),
  // ),

  //                   const SizedBox(height: 16),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 12,
  //                 ),
  //                 decoration: const BoxDecoration(
  //                   border: Border(top: BorderSide(color: Color(0xFFE3F2FD))),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     TextButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       style: TextButton.styleFrom(
  //                         foregroundColor: Colors.black54,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Cancel',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     ElevatedButton(
  //                       onPressed: () async {
  //                         if (nameController.text.isEmpty ||
  //                             qtyController.text.isEmpty)
  //                           return;

  //                         final double enteredPrice = double.parse(
  //                           qtyController.text,
  //                         );
  //                         final double pricePerKg = selectedUnit == 'Kg'
  //                             ? enteredPrice
  //                             : enteredPrice * 10;

  //                         final inventoryState = parentContext
  //                             .read<InventoryState>();

  //                         final success = await inventoryState.addInventoryItem(
  //                           productName: nameController.text,
  //                           pricePerKg: pricePerKg,
  //                           context: parentContext,
  //                         );

  //                         if (success) {
  //                           Navigator.pop(context);

  //                           parentContext.read<InventoryState>().fetchInventory(
  //                             context: parentContext,
  //                           );
  //                         } else {
  //                           ScaffoldMessenger.of(parentContext).showSnackBar(
  //                             const SnackBar(
  //                               content: Text('Failed to add item'),
  //                             ),
  //                           );
  //                         }
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: primaryBlue,
  //                         foregroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Add Item',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void _openAddItemDialog() {
    final parentContext = context;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();

    const Color primaryBlue = Color(0xFF2196F3);
    const Color lightBlueBg = Color(0xFFF8FBFF);

    String selectedUnit = 'Kg';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,

              // 🔹 TITLE
              title: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightBlueBg,
                  border: Border.all(color: primaryBlue, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Add New Item',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 CONTENT
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),

                  TextField(
                    controller: nameController,
                    cursorColor: const Color(0xFF2196F3), // Blue cursor
                    style: const TextStyle(
                      color: Color(0xFF263238), // Dark text color
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Item Name',
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

                  const SizedBox(height: 12),

                  // ✅ UNIT TOGGLE (Kg / 100 Gm)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UnitToggle(
                        label: 'Kg',
                        selected: selectedUnit == 'Kg',
                        onTap: () {
                          setDialogState(() {
                            selectedUnit = 'Kg';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      UnitToggle(
                        label: '100 Gm',
                        selected: selectedUnit == '100 Gm',
                        onTap: () {
                          setDialogState(() {
                            selectedUnit = '100 Gm';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Price
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    cursorColor: const Color(0xFF2196F3), // Blue cursor
                    style: const TextStyle(
                      color: Color(0xFF263238), // Dark text color
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Price per unit',
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
                ],
              ),

              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE3F2FD))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              qtyController.text.isEmpty)
                            return;

                          final double enteredPrice = double.parse(
                            qtyController.text,
                          );
                          final double pricePerKg = selectedUnit == 'Kg'
                              ? enteredPrice
                              : enteredPrice * 10;

                          final inventoryState = parentContext
                              .read<InventoryState>();

                          final success = await inventoryState.addInventoryItem(
                            productName: nameController.text,
                            pricePerKg: pricePerKg,
                            context: parentContext,
                          );

                          if (success) {
                            Navigator.pop(context);

                            parentContext.read<InventoryState>().fetchInventory(
                              context: parentContext,
                            );
                          } else {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to add item'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2196F3);
    const Color lightBlueBg = Color(0xFFF8FBFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Inventory',
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
        child: Column(
          children: [
            // 🔹 Add Item Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _openAddItemDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Add Item',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Items Count
            Row(
              children: [
                Text(
                  'All Items',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Consumer<InventoryState>(
                  builder: (context, state, _) {
                    return Container(
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
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Item List
            Consumer<InventoryState>(
              builder: (_, state, __) {
                if (state.items.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: lightBlueBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE3F2FD),
                              ),
                            ),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: primaryBlue.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No items added yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add your first item to get started',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryBlue.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: lightBlueBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE3F2FD)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (item.productName ?? '')
                                        .trim()
                                        .replaceFirstMapped(
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
                                  const SizedBox(height: 2),
                                  Text(
                                    "₹${item.pricePerKg?.toStringAsFixed(2)} / kg",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: primaryBlue,
                                ),
                              ),
                              onPressed: () {
                                _showUpdatePriceDialog(
                                  context: context,
                                  productId: item.id!,
                                  currentPrice: item.pricePerKg ?? 0,
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdatePriceDialog({
    required BuildContext context,
    required int productId,
    required double currentPrice,
  }) {
    final TextEditingController priceController = TextEditingController(
      text: currentPrice.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        const Color primaryBlue = Color(0xFF2196F3);
        const Color lightBlueBg = Color(0xFFF8FBFF);

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightBlueBg,
              border: Border.all(color: primaryBlue, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Update Price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xFF2196F3), // Blue cursor
                  style: const TextStyle(
                    color: Color(0xFF263238), // Dark text color
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter new price per kg',
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
              ],
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE3F2FD))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final newPrice = double.tryParse(
                        priceController.text.trim(),
                      );

                      if (newPrice == null || newPrice <= 0) {
                        Util.snackBarNew("Enter valid price");
                        return;
                      }

                      Navigator.pop(ctx);

                      final success = await context
                          .read<InventoryState>()
                          .updateProductPrice(
                            productId: productId,
                            pricePerKg: newPrice,
                            context: context,
                          );

                      if (success) {
                        Util.snackBarNew("Price updated successfully");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
