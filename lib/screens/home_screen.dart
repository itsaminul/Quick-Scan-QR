import 'package:flutter/material.dart';
import 'package:quickscan_qr/screens/favorite_screen.dart';
import '../widgets/home_button.dart';
import 'scan_screen.dart';
import 'generate_screen.dart';
import 'history_screen.dart' hide GenerateScreen;
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "QuickScan QR",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome 👋",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Scan & generate QR or Barcode easily",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    HomeButton(
                      icon: Icons.qr_code_scanner,
                      title: "Scan",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScanScreen()),
                        );
                      },
                    ),
                    HomeButton(
                      icon: Icons.qr_code,
                      title: "Generate",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GenerateScreen()),
                        );
                      },
                    ),
                    HomeButton(
                      icon: Icons.history,
                      title: "History",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HistoryScreen()),
                        );
                      },
                    ),
                    HomeButton(
                      icon: Icons.favorite,
                      title: "Favorite",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const FavoriteScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "© 2026 Aminul Islam. All rights reserved.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
