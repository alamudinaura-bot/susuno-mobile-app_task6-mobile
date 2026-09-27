import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/stock_provider.dart';
import 'views/main_navigation.dart';

void main() {
  runApp(const SusunoApp());
}

class SusunoApp extends StatelessWidget {
  const SusunoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockProvider(),
      child: MaterialApp(
        title: 'SUSUNO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF5B6A32),
          scaffoldBackgroundColor: const Color(0xFFF5F6F2),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}
