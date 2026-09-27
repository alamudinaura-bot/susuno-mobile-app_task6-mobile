import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'stock_screen.dart';
import 'scanner_screen.dart';
import 'widgets/app_drawer.dart';

/// Holds which tab is active so any screen (e.g. the "Scan Bin" button on
/// StockScreen) can jump the user into the Scanner tab.
class NavIndexProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void setIndex(int i) {
    _index = i;
    notifyListeners();
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavIndexProvider(),
      child: Consumer<NavIndexProvider>(
        builder: (context, nav, _) {
          return Scaffold(
            drawer: const AppDrawer(),
            appBar: AppBar(
              backgroundColor: kSusunoGreen,
              foregroundColor: Colors.white,
              centerTitle: true,
              title: const Text('SUSUNO', style: TextStyle(fontWeight: FontWeight.bold)),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.account_circle_outlined),
                ),
              ],
            ),
            body: IndexedStack(
              index: nav.index,
              children: const [
                DashboardScreen(),
                StockScreen(),
                ScannerScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: nav.index,
              onTap: nav.setIndex,
              selectedItemColor: const Color(0xFF5B6A32),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2_outlined), label: 'Stock'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
              ],
            ),
          );
        },
      ),
    );
  }
}
