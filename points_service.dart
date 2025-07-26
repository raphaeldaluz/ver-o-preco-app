import 'package:flutter/material.dart';
import 'database_service.dart';
import 'auth_service.dart';
import 'notification_service.dart';

class PointsService {
  // Tipos de ações que geram pontos
  static const String ACTION_QR_SCAN = 'qr_scan';
  static const String ACTION_BARCODE_SCAN = 'barcode_scan';
  static const String ACTION_FIRST_LOGIN = 'first_login';
  static const String ACTION_PROFILE_COMPLETE = 'profile_complete';
  static const String ACTION_FAVORITE_PRODUCT = 'favorite_product';
  static const String ACTION_CREATE_LIST = 'create_list';
  static const String ACTION_SHARE_APP = 'share_app';
  static const String ACTION_DAILY_LOGIN = 'daily_login';
  static const String ACTION_WEEKLY_STREAK = 'weekly_streak';
  static const String ACTION_MONTHLY_STREAK = 'monthly_streak';

  // Pontos por ação
  static const Map<String, int> POINTS_PER_ACTION = {
    ACTION_QR_SCAN: 10,
    ACTION_BARCODE_SCAN: 5,
    ACTION_FIRST_LOGIN: 50,
    ACTION_PROFILE_COMPLETE: 25,
    ACTION_FAVORITE_PRODUCT: 2,
    ACTION_CREATE_LIST: 15,
    ACTION_SHARE_APP: 30,
    ACTION_DAILY_LOGIN: 5,
    ACTION_WEEKLY_STREAK: 50,
    ACTION_MONTHLY_STREAK: 200,
  };

  // Níveis e pontos necessários
  static const Map<int, Map<String, dynamic>> LEVELS = {
    1: {'name': 'Iniciante', 'points': 0, 'color': 0xFF4CAF50},
    2: {'name': 'Explorador', 'points': 100, 'color': 0xFF2196F3},
    3: {'name': 'Caçador de Ofertas', 'points': 300, 'color': 0xFF9C27B0},
    4: {'name': 'Expert em Economia', 'points': 600, 'color': 0xFFFF9800},
    5: {'name': 'Mestre das Compras', 'points': 1000, 'color': 0xFFF44336},
    6: {'name': 'Lenda do Ver-o-Preço', 'points': 1500, 'color': 0xFFFFD700},
  };

  // Recompensas disponíveis
  static const Map<String, Map<String, dynamic>> REWARDS = {
    'desconto_5': {
      'name': 'Desconto 5%',
      'description': 'Desconto de 5% em parceiros',
      'points_cost': 100,
      'icon': Icons.local_offer,
      'color': 0xFF4CAF50,
    },
    'desconto_10': {
      'name': 'Desconto 10%',
      'description': 'Desconto de 10% em parceiros',
      'points_cost': 200,
      'icon': Icons.card_giftcard,
      'color': 0xFF2196F3,
    },
    'frete_gratis': {
      'name': 'Frete Grátis',
      'description': 'Frete grátis em delivery',
      'points_cost': 150,
      'icon': Icons.local_shipping,
      'color': 0xFF9C27B0,
    },
    'cashback_2': {
      'name': 'Cashback 2%',
      'description': 'Cashback de 2% em compras',
      'points_cost': 300,
      'icon': Icons.account_balance_wallet,
      'color': 0xFFFF9800,
    },
    'produto_gratis': {
      'name': 'Produto Grátis',
      'description': 'Produto grátis até R\$ 10',
      'points_cost': 500,
      'icon': Icons.redeem,
      'color': 0xFFF44336,
    },
  };

  // Adicionar pontos para um usuário
  static Future<Map<String, dynamic>> addPoints({
    required int userId,
    required String action,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final pointsToAdd = POINTS_PER_ACTION[action] ?? 0;
      if (pointsToAdd == 0) {
        return {'success': false, 'message': 'Ação inválida'};
      }

      // Verificar se já ganhou pontos por essa ação hoje (para algumas ações)
      if (_isDailyAction(action)) {
        final alreadyEarned = await _hasEarnedTodayForAction(userId, action);
        if (alreadyEarned) {
          return {'success': false, 'message': 'Pontos já ganhos hoje para esta ação'};
        }
      }

      // Obter pontos atuais do usuário
      final currentUser = await DatabaseService.getUserById(userId);
      if (currentUser == null) {
        return {'success': false, 'message': 'Usuário não encontrado'};
      }

      final currentPoints = currentUser.pontos;
      final newPoints = currentPoints + pointsToAdd;

      // Verificar mudança de nível
      final currentLevel = getUserLevel(currentPoints);
      final newLevel = getUserLevel(newPoints);
      final leveledUp = newLevel > currentLevel;

      // Atualizar pontos do usuário
      await DatabaseService.updateUserPoints(userId, newPoints);

      // Registrar no histórico
      await DatabaseService.insertPointsHistory({
        'user_id': userId,
        'action': action,
        'points': pointsToAdd,
        'description': description ?? getActionDescription(action),
        'metadata': metadata != null ? metadata.toString() : null,
        'data_criacao': DateTime.now().millisecondsSinceEpoch,
      });

      // Notificar sobre pontos ganhos
      await NotificationService.notifyPointsEarned(
        pontos: pointsToAdd,
        motivo: description ?? getActionDescription(action),
      );

      // Notificar sobre mudança de nível
      if (leveledUp) {
        final levelInfo = LEVELS[newLevel]!;
        await NotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 10000,
          title: '🎉 Parabéns! Você subiu de nível!',
          body: 'Agora você é ${levelInfo['name']}! Continue economizando!',
          payload: 'level_up:$newLevel',
        );
      }

      return {
        'success': true,
        'message': 'Pontos adicionados com sucesso',
        'points_added': pointsToAdd,
        'total_points': newPoints,
        'leveled_up': leveledUp,
        'new_level': newLevel,
      };
    } catch (e) {
      debugPrint('Erro ao adicionar pontos: $e');
      return {'success': false, 'message': 'Erro interno'};
    }
  }

  // Verificar se é uma ação diária (limitada a uma vez por dia)
  static bool _isDailyAction(String action) {
    return [
      ACTION_DAILY_LOGIN,
      ACTION_QR_SCAN, // Limitar QR scan a uma vez por dia para evitar spam
    ].contains(action);
  }

  // Verificar se já ganhou pontos hoje para uma ação específica
  static Future<bool> _hasEarnedTodayForAction(int userId, String action) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final history = await DatabaseService.getPointsHistoryByPeriod(
      userId,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    );

    return history.any((entry) => entry['action'] == action);
  }

  // Obter descrição da ação
  static String getActionDescription(String action) {
    switch (action) {
      case ACTION_QR_SCAN:
        return 'Escaneou QR Code de nota fiscal';
      case ACTION_BARCODE_SCAN:
        return 'Escaneou código de barras';
      case ACTION_FIRST_LOGIN:
        return 'Primeiro login no app';
      case ACTION_PROFILE_COMPLETE:
        return 'Completou o perfil';
      case ACTION_FAVORITE_PRODUCT:
        return 'Favoritou um produto';
      case ACTION_CREATE_LIST:
        return 'Criou uma lista de compras';
      case ACTION_SHARE_APP:
        return 'Compartilhou o app';
      case ACTION_DAILY_LOGIN:
        return 'Login diário';
      case ACTION_WEEKLY_STREAK:
        return 'Sequência semanal';
      case ACTION_MONTHLY_STREAK:
        return 'Sequência mensal';
      default:
        return 'Ação realizada';
    }
  }

  // Obter nível do usuário baseado nos pontos
  static int getUserLevel(int points) {
    int level = 1;
    for (final entry in LEVELS.entries) {
      if (points >= entry.value['points']) {
        level = entry.key;
      } else {
        break;
      }
    }
    return level;
  }

  // Obter informações do nível
  static Map<String, dynamic> getLevelInfo(int level) {
    return LEVELS[level] ?? LEVELS[1]!;
  }

  // Obter progresso para o próximo nível
  static Map<String, dynamic> getLevelProgress(int points) {
    final currentLevel = getUserLevel(points);
    final nextLevel = currentLevel + 1;
    
    if (!LEVELS.containsKey(nextLevel)) {
      // Já está no nível máximo
      return {
        'current_level': currentLevel,
        'next_level': null,
        'progress': 1.0,
        'points_needed': 0,
        'is_max_level': true,
      };
    }

    final currentLevelPoints = LEVELS[currentLevel]!['points'] as int;
    final nextLevelPoints = LEVELS[nextLevel]!['points'] as int;
    final pointsInCurrentLevel = points - currentLevelPoints;
    final pointsNeededForNext = nextLevelPoints - currentLevelPoints;
    final progress = pointsInCurrentLevel / pointsNeededForNext;

    return {
      'current_level': currentLevel,
      'next_level': nextLevel,
      'progress': progress.clamp(0.0, 1.0),
      'points_needed': nextLevelPoints - points,
      'is_max_level': false,
    };
  }

  // Resgatar recompensa
  static Future<Map<String, dynamic>> redeemReward({
    required int userId,
    required String rewardId,
  }) async {
    try {
      final reward = REWARDS[rewardId];
      if (reward == null) {
        return {'success': false, 'message': 'Recompensa não encontrada'};
      }

      final user = await DatabaseService.getUserById(userId);
      if (user == null) {
        return {'success': false, 'message': 'Usuário não encontrado'};
      }

      final currentPoints = user.pontos;
      final cost = reward['points_cost'] as int;

      if (currentPoints < cost) {
        return {
          'success': false,
          'message': 'Pontos insuficientes',
          'points_needed': cost - currentPoints,
        };
      }

      // Deduzir pontos
      final newPoints = currentPoints - cost;
      await DatabaseService.updateUserPoints(userId, newPoints);

      // Registrar no histórico
      await DatabaseService.insertPointsHistory({
        'user_id': userId,
        'action': 'reward_redeemed',
        'points': -cost,
        'description': 'Resgatou: ${reward['name']}',
        'metadata': rewardId,
        'data_criacao': DateTime.now().millisecondsSinceEpoch,
      });

      // Notificar sobre resgate
      await NotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 20000,
        title: '🎁 Recompensa resgatada!',
        body: 'Você resgatou: ${reward['name']}',
        payload: 'reward_redeemed:$rewardId',
      );

      return {
        'success': true,
        'message': 'Recompensa resgatada com sucesso',
        'reward': reward,
        'points_spent': cost,
        'remaining_points': newPoints,
      };
    } catch (e) {
      debugPrint('Erro ao resgatar recompensa: $e');
      return {'success': false, 'message': 'Erro interno'};
    }
  }

  // Obter estatísticas do usuário
  static Future<Map<String, dynamic>> getUserStats(int userId) async {
    try {
      final user = await DatabaseService.getUserById(userId);
      if (user == null) {
        return {'success': false, 'message': 'Usuário não encontrado'};
      }

      final points = user.pontos;
      final levelProgress = getLevelProgress(points);
      final history = await DatabaseService.getUserPointsHistory(userId);

      // Calcular estatísticas
      final totalEarned = history
          .where((entry) => (entry['points'] as int) > 0)
          .fold(0, (sum, entry) => sum + (entry['points'] as int));

      final totalSpent = history
          .where((entry) => (entry['points'] as int) < 0)
          .fold(0, (sum, entry) => sum + (entry['points'] as int).abs());

      final actionsCount = <String, int>{};
      for (final entry in history) {
        final action = entry['action'] as String;
        actionsCount[action] = (actionsCount[action] ?? 0) + 1;
      }

      return {
        'success': true,
        'current_points': points,
        'total_earned': totalEarned,
        'total_spent': totalSpent,
        'level_info': levelProgress,
        'actions_count': actionsCount,
        'history_count': history.length,
      };
    } catch (e) {
      debugPrint('Erro ao obter estatísticas: $e');
      return {'success': false, 'message': 'Erro interno'};
    }
  }

  // Obter ranking de usuários
  static Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      return await DatabaseService.getUsersLeaderboard(limit);
    } catch (e) {
      debugPrint('Erro ao obter ranking: $e');
      return [];
    }
  }

  // Verificar e processar sequências (streaks)
  static Future<void> checkAndProcessStreaks(int userId) async {
    try {
      final loginHistory = await DatabaseService.getUserLoginHistory(userId);
      
      // Verificar sequência semanal (7 dias consecutivos)
      if (_hasWeeklyStreak(loginHistory)) {
        await addPoints(
          userId: userId,
          action: ACTION_WEEKLY_STREAK,
          description: 'Completou 7 dias consecutivos',
        );
      }

      // Verificar sequência mensal (30 dias consecutivos)
      if (_hasMonthlyStreak(loginHistory)) {
        await addPoints(
          userId: userId,
          action: ACTION_MONTHLY_STREAK,
          description: 'Completou 30 dias consecutivos',
        );
      }
    } catch (e) {
      debugPrint('Erro ao verificar sequências: $e');
    }
  }

  // Verificar sequência semanal
  static bool _hasWeeklyStreak(List<Map<String, dynamic>> loginHistory) {
    if (loginHistory.length < 7) return false;

    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final targetDate = now.subtract(Duration(days: i));
      final hasLoginOnDate = loginHistory.any((login) {
        final loginDate = DateTime.fromMillisecondsSinceEpoch(login['data_ultimo_login']);
        return _isSameDay(loginDate, targetDate);
      });
      
      if (!hasLoginOnDate) return false;
    }
    
    return true;
  }

  // Verificar sequência mensal
  static bool _hasMonthlyStreak(List<Map<String, dynamic>> loginHistory) {
    if (loginHistory.length < 30) return false;

    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final targetDate = now.subtract(Duration(days: i));
      final hasLoginOnDate = loginHistory.any((login) {
        final loginDate = DateTime.fromMillisecondsSinceEpoch(login['data_ultimo_login']);
        return _isSameDay(loginDate, targetDate);
      });
      
      if (!hasLoginOnDate) return false;
    }
    
    return true;
  }

  // Verificar se duas datas são do mesmo dia
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Obter recompensas disponíveis para o usuário
  static List<Map<String, dynamic>> getAvailableRewards(int userPoints) {
    return REWARDS.entries.map((entry) {
      final reward = Map<String, dynamic>.from(entry.value);
      reward['id'] = entry.key;
      reward['can_afford'] = userPoints >= (reward['points_cost'] as int);
      return reward;
    }).toList();
  }

  // Processar login diário
  static Future<void> processDailyLogin(int userId) async {
    await addPoints(
      userId: userId,
      action: ACTION_DAILY_LOGIN,
      description: 'Login diário realizado',
    );

    // Verificar sequências
    await checkAndProcessStreaks(userId);
  }
}

