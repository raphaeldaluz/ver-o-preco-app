import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static User? _currentUser;

  // Getter para usuário atual
  static User? get currentUser => _currentUser;

  // Verificar se usuário está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Carregar dados do usuário do storage local
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_keyUserData);
    
    if (userData != null) {
      final userMap = jsonDecode(userData);
      _currentUser = User.fromMap(userMap);
    }
  }

  // Salvar dados do usuário no storage local
  static Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, user.id!);
    await prefs.setString(_keyUserData, jsonEncode(user.toMap()));
    await prefs.setBool(_keyIsLoggedIn, true);
    _currentUser = user;
  }

  // Limpar dados do usuário
  static Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserData);
    await prefs.setBool(_keyIsLoggedIn, false);
    _currentUser = null;
  }

  // Hash da senha
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validar CPF
  static bool isValidCPF(String cpf) {
    // Remove caracteres não numéricos
    final digits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Verifica se tem 11 dígitos
    if (digits.length != 11) return false;
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(digits)) return false;
    
    // Validação do primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(digits[i]) * (10 - i);
    }
    int firstDigit = (sum * 10) % 11;
    if (firstDigit == 10) firstDigit = 0;
    
    if (firstDigit != int.parse(digits[9])) return false;
    
    // Validação do segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(digits[i]) * (11 - i);
    }
    int secondDigit = (sum * 10) % 11;
    if (secondDigit == 10) secondDigit = 0;
    
    return secondDigit == int.parse(digits[10]);
  }

  // Validar email
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Validar telefone
  static bool isValidPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 10 && digits.length <= 11;
  }

  // Validar senha
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Formatar CPF
  static String formatCPF(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
    }
    return cpf;
  }

  // Formatar telefone
  static String formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    } else if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6, 10)}';
    }
    return phone;
  }

  // Cadastrar usuário
  static Future<Map<String, dynamic>> register({
    required String nomeCompleto,
    required String email,
    required String telefone,
    required String cpf,
    required String senha,
  }) async {
    try {
      // Validações
      if (nomeCompleto.trim().isEmpty) {
        return {'success': false, 'message': 'Nome completo é obrigatório'};
      }

      if (!isValidEmail(email)) {
        return {'success': false, 'message': 'Email inválido'};
      }

      if (!isValidPhone(telefone)) {
        return {'success': false, 'message': 'Telefone inválido'};
      }

      if (!isValidCPF(cpf)) {
        return {'success': false, 'message': 'CPF inválido'};
      }

      if (!isValidPassword(senha)) {
        return {'success': false, 'message': 'Senha deve ter pelo menos 6 caracteres'};
      }

      // Verificar se email já existe
      if (await DatabaseService.emailExists(email)) {
        return {'success': false, 'message': 'Email já cadastrado'};
      }

      // Verificar se CPF já existe
      final cpfDigits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      if (await DatabaseService.cpfExists(cpfDigits)) {
        return {'success': false, 'message': 'CPF já cadastrado'};
      }

      // Criar usuário
      final user = User(
        nomeCompleto: nomeCompleto.trim(),
        email: email.toLowerCase().trim(),
        telefone: telefone.replaceAll(RegExp(r'[^0-9]'), ''),
        cpf: cpfDigits,
        senha: _hashPassword(senha),
        pontos: 50, // Pontos de boas-vindas
        dataCadastro: DateTime.now(),
      );

      // Salvar no banco
      final userId = await DatabaseService.insertUser(user);
      final savedUser = user.copyWith(id: userId);

      // Adicionar transação de pontos de boas-vindas
      await DatabaseService.addPointsTransaction(
        userId,
        50,
        'bonus',
        'Pontos de boas-vindas',
      );

      // Salvar sessão
      await _saveUserData(savedUser);

      return {
        'success': true,
        'message': 'Cadastro realizado com sucesso!',
        'user': savedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro interno: $e',
      };
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      // Validações básicas
      if (email.trim().isEmpty) {
        return {'success': false, 'message': 'Email é obrigatório'};
      }

      if (senha.trim().isEmpty) {
        return {'success': false, 'message': 'Senha é obrigatória'};
      }

      // Buscar usuário por email
      final user = await DatabaseService.getUserByEmail(email.toLowerCase().trim());
      
      if (user == null) {
        return {'success': false, 'message': 'Email não encontrado'};
      }

      // Verificar senha
      final hashedPassword = _hashPassword(senha);
      if (user.senha != hashedPassword) {
        return {'success': false, 'message': 'Senha incorreta'};
      }

      // Atualizar último login
      await DatabaseService.updateLastLogin(user.id!);
      
      // Buscar dados atualizados
      final updatedUser = await DatabaseService.getUserById(user.id!);
      
      // Salvar sessão
      await _saveUserData(updatedUser!);

      return {
        'success': true,
        'message': 'Login realizado com sucesso!',
        'user': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro interno: $e',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    await _clearUserData();
  }

  // Atualizar perfil
  static Future<Map<String, dynamic>> updateProfile({
    required String nomeCompleto,
    required String email,
    required String telefone,
  }) async {
    try {
      if (_currentUser == null) {
        return {'success': false, 'message': 'Usuário não logado'};
      }

      // Validações
      if (nomeCompleto.trim().isEmpty) {
        return {'success': false, 'message': 'Nome completo é obrigatório'};
      }

      if (!isValidEmail(email)) {
        return {'success': false, 'message': 'Email inválido'};
      }

      if (!isValidPhone(telefone)) {
        return {'success': false, 'message': 'Telefone inválido'};
      }

      // Verificar se email já existe (exceto o próprio usuário)
      final existingUser = await DatabaseService.getUserByEmail(email);
      if (existingUser != null && existingUser.id != _currentUser!.id) {
        return {'success': false, 'message': 'Email já cadastrado por outro usuário'};
      }

      // Atualizar usuário
      final updatedUser = _currentUser!.copyWith(
        nomeCompleto: nomeCompleto.trim(),
        email: email.toLowerCase().trim(),
        telefone: telefone.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      // Salvar no banco
      await DatabaseService.updateUser(updatedUser);

      // Atualizar sessão
      await _saveUserData(updatedUser);

      return {
        'success': true,
        'message': 'Perfil atualizado com sucesso!',
        'user': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro interno: $e',
      };
    }
  }

  // Alterar senha
  static Future<Map<String, dynamic>> changePassword({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    try {
      if (_currentUser == null) {
        return {'success': false, 'message': 'Usuário não logado'};
      }

      // Verificar senha atual
      final hashedCurrentPassword = _hashPassword(senhaAtual);
      if (_currentUser!.senha != hashedCurrentPassword) {
        return {'success': false, 'message': 'Senha atual incorreta'};
      }

      // Validar nova senha
      if (!isValidPassword(novaSenha)) {
        return {'success': false, 'message': 'Nova senha deve ter pelo menos 6 caracteres'};
      }

      // Atualizar senha
      final updatedUser = _currentUser!.copyWith(
        senha: _hashPassword(novaSenha),
      );

      // Salvar no banco
      await DatabaseService.updateUser(updatedUser);

      // Atualizar sessão
      await _saveUserData(updatedUser);

      return {
        'success': true,
        'message': 'Senha alterada com sucesso!',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro interno: $e',
      };
    }
  }

  // Adicionar pontos
  static Future<void> addPoints(int pontos, String tipo, String descricao) async {
    if (_currentUser == null) return;

    try {
      // Atualizar pontos no banco
      final newPoints = _currentUser!.pontos + pontos;
      await DatabaseService.updateUserPoints(_currentUser!.id!, newPoints);

      // Adicionar transação
      await DatabaseService.addPointsTransaction(
        _currentUser!.id!,
        pontos,
        tipo,
        descricao,
      );

      // Atualizar usuário atual
      final updatedUser = _currentUser!.copyWith(pontos: newPoints);
      await _saveUserData(updatedUser);
    } catch (e) {
      // Log do erro
      print('Erro ao adicionar pontos: $e');
    }
  }

  // Recarregar dados do usuário
  static Future<void> refreshUserData() async {
    if (_currentUser == null) return;

    try {
      final updatedUser = await DatabaseService.getUserById(_currentUser!.id!);
      if (updatedUser != null) {
        await _saveUserData(updatedUser);
      }
    } catch (e) {
      print('Erro ao recarregar dados do usuário: $e');
    }
  }
}

