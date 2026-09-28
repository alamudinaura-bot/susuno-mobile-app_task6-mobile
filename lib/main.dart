import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/stock_provider.dart';
import 'views/login_screen.dart';
import 'views/main_navigation.dart';

void main() {
  runApp(const SusunoApp());
}

class SusunoApp extends StatelessWidget {
  const SusunoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'SUSUNO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF5B6A32),
          scaffoldBackgroundColor: const Color(0xFFF5F6F2),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// Shows the LoginScreen until the user signs in, then the main app.
/// Logging out (Profile page) flips this back to LoginScreen automatically.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);
    return loggedIn ? const MainNavigationScreen() : const LoginScreen();
  }
}
