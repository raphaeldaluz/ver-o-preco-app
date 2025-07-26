import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'home/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Aguardar um pouco para mostrar o splash
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Verificar se usuário está logado
      final isLoggedIn = await AuthService.isLoggedIn();
      
      if (isLoggedIn) {
        // Carregar dados do usuário
        await AuthService.loadUserData();
        
        // Navegar para tela principal
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
      } else {
        // Navegar para tela de login
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      }
    } catch (e) {
      // Em caso de erro, ir para login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteVeroPreco,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.branco.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(75),
                          border: Border.all(
                            color: AppColors.branco.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          size: 80,
                          color: AppColors.branco,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Nome do app
                      const Text(
                        'Ver-o-Preço',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.branco,
                          letterSpacing: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Slogan
                      Text(
                        'Tradição paraense em suas compras',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.branco.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.branco.withOpacity(0.8),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Carregando...',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.branco.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

