import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'home_tab.dart';
import 'scanner_tab.dart';
import 'lists_tab.dart';
import 'profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _tabs = [
    const HomeTab(),
    const ScannerTab(),
    const ListsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.backgroundPrimario,
          selectedItemColor: AppColors.azulVeroPreco,
          unselectedItemColor: AppColors.textoSecundario,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_outlined),
              activeIcon: Icon(Icons.qr_code_scanner),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Listas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1 ? null : FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 1; // Ir para aba do scanner
          });
        },
        backgroundColor: AppColors.laranjaTucuma,
        child: const Icon(
          Icons.qr_code_scanner,
          color: AppColors.branco,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

