import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/auth_service.dart';
import '../home/main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.login(
        email: _emailController.text,
        senha: _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result['success']) {
          // Login bem-sucedido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppColors.sucesso,
            ),
          );

          // Navegar para tela principal
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        } else {
          // Erro no login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppColors.erro,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado: $e'),
            backgroundColor: AppColors.erro,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimario,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // Logo e título
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradienteVeroPreco,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 60,
                        color: AppColors.branco,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ver-o-Preço',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.azulVeroPreco,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tradição paraense em suas compras',
                      style: AppStyles.corpoPequeno,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Formulário de login
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Entrar na sua conta',
                      style: AppStyles.subtitulo,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Campo de email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email é obrigatório';
                        }
                        if (!AuthService.isValidEmail(value)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: AppStyles.inputDecoration.copyWith(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Senha é obrigatória';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botão de login
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: AppStyles.botaoPrimario,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.branco,
                              )
                            : const Text('Entrar'),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Link para esqueci a senha
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidade em desenvolvimento'),
                          ),
                        );
                      },
                      child: const Text('Esqueci minha senha'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Divisor
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ou',
                        style: AppStyles.corpoPequeno,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Botão de cadastro
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: AppStyles.botaoSecundario,
                  child: const Text('Criar nova conta'),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

