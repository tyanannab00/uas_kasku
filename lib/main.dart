import 'package:flutter/material.dart';
import 'package:uas_kasku/pages/dashboard_page.dart';
import 'package:uas_kasku/pages/login_page.dart';
import 'package:uas_kasku/services/auth_service.dart';

void main() {
  runApp(const KasKuApp());
}

class KasKuApp extends StatelessWidget {
  const KasKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KasKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // 🔹 Menentukan halaman awal
    );
  }
}

/// 🔹 SplashScreen akan menentukan apakah user sudah login atau belum
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();

    // Simulasi delay biar ada efek loading
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // 🔹 Arahkan ke halaman sesuai status login
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.account_balance_wallet, color: Colors.white, size: 90),
            SizedBox(height: 16),
            Text(
              "KasKu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
