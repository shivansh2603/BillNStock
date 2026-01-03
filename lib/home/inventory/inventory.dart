import 'package:bill_n_stock/home/inventory/inventory_state.dart';
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

  void _openAddItemDialog() {
    final parentContext = context;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();
    String selectedUnit = 'Kg';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Item Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),

              const SizedBox(height: 12),

              // Quantity

              // Unit Dropdown
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: const [
                  DropdownMenuItem(value: 'Kg', child: Text('Kg')),
                  DropdownMenuItem(value: '100 Gm', child: Text('100 Gm')),
                ],
                onChanged: (value) {
                  selectedUnit = value!;
                },
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),

              const SizedBox(height: 12),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || qtyController.text.isEmpty)
                  return;

                final double enteredPrice = double.parse(qtyController.text);
                final double pricePerKg = selectedUnit == 'Kg'
                    ? enteredPrice
                    : enteredPrice * 10;

                final inventoryState = parentContext.read<InventoryState>();

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
                    const SnackBar(content: Text('Failed to add item')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Inventory', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Add Item Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openAddItemDialog,
                child: const Text('Add Item'),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Item List
            Consumer<InventoryState>(
              builder: (_, state, __) {
                if (state.isLoading) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.items.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        'No items added',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.productName ?? ""),
                        subtitle: Text("₹ ${item.pricePerKg}/kg"),
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
}
