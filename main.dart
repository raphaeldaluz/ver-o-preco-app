import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const VeroPrecoApp());
}

class VeroPrecoApp extends StatelessWidget {
  const VeroPrecoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ver-o-Preço',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.azulVeroPreco,
          primary: AppColors.azulVeroPreco,
          secondary: AppColors.laranjaTucuma,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.azulVeroPreco,
          foregroundColor: AppColors.branco,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.azulVeroPreco,
            foregroundColor: AppColors.branco,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.azulVeroPreco,
              width: 2,
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
