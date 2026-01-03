import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/home/bill/bill_screen.dart';
import 'package:bill_n_stock/home/bill/bill_state.dart';
import 'package:bill_n_stock/home/inventory/inventory.dart';
import 'package:bill_n_stock/home/inventory/inventory_state.dart';
import 'package:bill_n_stock/auth/login/login.dart';
import 'package:bill_n_stock/helper/pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,

        // 🔹 APP BAR
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'BillNStock',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),

        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                // 🔹 HEADER WITH CLOSE ICON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40), // balance spacing
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context); // 👈 close drawer
                        },
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32),

                // 🔹 LOGOUT ACTION
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    await Pref.removeValue(PreferenceKey.isLogin.toString());
                    await Pref.removeValue(PreferenceKey.userData.toString());

                    Navigator.pushAndRemoveUntil(
                      context,
                      smoothRoute(const SignInPage()),
                      (route) => false,
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),

              _homeCard(
                title: 'Create Bill',
                icon: Icons.receipt_long,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => BillState(),
                        child: const BillScreen(),
                      ),
                    ),
                  );
                },
              ),

              const Divider(height: 1),

              _homeCard(
                title: 'Inventory',
                icon: Icons.inventory_2_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => InventoryState(),
                        child: const InventoryScreen(),
                      ),
                    ),
                  );
                },
              ),

              const Divider(height: 1),

              _homeCard(
                title: 'User Bill History',
                icon: Icons.history,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.black),
            const SizedBox(width: 16),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            const Spacer(),

            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
