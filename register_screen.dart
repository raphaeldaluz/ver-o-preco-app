import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/auth_service.dart';
import '../home/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _formatCPF(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length <= 3) return value;
    if (value.length <= 6) return '${value.substring(0, 3)}.${value.substring(3)}';
    if (value.length <= 9) return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6)}';
    return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9, 11)}';
  }

  String _formatPhone(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length <= 2) return value;
    if (value.length <= 7) return '(${value.substring(0, 2)}) ${value.substring(2)}';
    if (value.length <= 11) {
      if (value.length == 11) {
        return '(${value.substring(0, 2)}) ${value.substring(2, 7)}-${value.substring(7)}';
      } else {
        return '(${value.substring(0, 2)}) ${value.substring(2, 6)}-${value.substring(6)}';
      }
    }
    return value;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você deve aceitar os termos de uso'),
          backgroundColor: AppColors.aviso,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.register(
        nomeCompleto: _nomeController.text,
        email: _emailController.text,
        telefone: _telefoneController.text,
        cpf: _cpfController.text,
        senha: _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result['success']) {
          // Cadastro bem-sucedido
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
          // Erro no cadastro
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
      appBar: AppBar(
        backgroundColor: AppColors.azulVeroPreco,
        title: const Text(
          'Criar Conta',
          style: TextStyle(color: AppColors.branco),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.branco),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                
                // Título
                const Text(
                  'Crie sua conta no Ver-o-Preço',
                  style: AppStyles.subtitulo,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preencha seus dados para começar a economizar',
                  style: AppStyles.corpoPequeno,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Campo nome completo
                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'Nome Completo',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nome completo é obrigatório';
                    }
                    if (value.trim().split(' ').length < 2) {
                      return 'Digite seu nome completo';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Campo email
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
                
                // Campo telefone
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'Telefone',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    hintText: '(11) 99999-9999',
                  ),
                  onChanged: (value) {
                    final formatted = _formatPhone(value);
                    if (formatted != value) {
                      _telefoneController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telefone é obrigatório';
                    }
                    if (!AuthService.isValidPhone(value)) {
                      return 'Telefone inválido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Campo CPF
                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'CPF',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    hintText: '000.000.000-00',
                  ),
                  onChanged: (value) {
                    final formatted = _formatCPF(value);
                    if (formatted != value) {
                      _cpfController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CPF é obrigatório';
                    }
                    if (!AuthService.isValidCPF(value)) {
                      return 'CPF inválido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Campo senha
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
                    if (!AuthService.isValidPassword(value)) {
                      return 'Senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Campo confirmar senha
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'Confirmar Senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmação de senha é obrigatória';
                    }
                    if (value != _passwordController.text) {
                      return 'Senhas não coincidem';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Checkbox termos
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.azulVeroPreco,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: const Text(
                          'Aceito os termos de uso e política de privacidade',
                          style: AppStyles.corpoPequeno,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Botão de cadastro
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: AppStyles.botaoPrimario,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.branco,
                          )
                        : const Text('Criar Conta'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Link para login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já tem uma conta? ',
                      style: AppStyles.corpoPequeno,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Entrar'),
                    ),
                  ],
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

