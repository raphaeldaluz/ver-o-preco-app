import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/points_service.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _userStats;
  List<Map<String, dynamic>> _availableRewards = [];
  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthService.currentUser;
      if (user != null) {
        // Carregar estatísticas do usuário
        final stats = await PointsService.getUserStats(user.id!);
        if (stats['success']) {
          _userStats = stats;
        }

        // Carregar recompensas disponíveis
        final userPoints = user.pontos;
        _availableRewards = PointsService.getAvailableRewards(userPoints);

        // Carregar leaderboard
        _leaderboard = await PointsService.getLeaderboard(limit: 10);
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _redeemReward(String rewardId) async {
    final user = AuthService.currentUser;
    if (user == null) return;

    // Mostrar confirmação
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Resgate'),
        content: const Text('Deseja realmente resgatar esta recompensa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Resgatar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Processar resgate
    final result = await PointsService.redeemReward(
      userId: user.id!,
      rewardId: rewardId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? AppColors.sucesso : AppColors.erro,
        ),
      );

      if (result['success']) {
        // Recarregar dados
        _loadData();
        
        // Atualizar usuário atual
        await AuthService.loadUserData();
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
          'Pontos e Recompensas',
          style: TextStyle(color: AppColors.branco),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.branco),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.branco,
          labelColor: AppColors.branco,
          unselectedLabelColor: AppColors.branco.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Meus Pontos'),
            Tab(text: 'Recompensas'),
            Tab(text: 'Ranking'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPointsTab(),
                _buildRewardsTab(),
                _buildLeaderboardTab(),
              ],
            ),
    );
  }

  Widget _buildPointsTab() {
    final user = AuthService.currentUser;
    if (user == null || _userStats == null) {
      return const Center(child: Text('Erro ao carregar dados'));
    }

    final levelInfo = _userStats!['level_info'];
    final currentLevel = levelInfo['current_level'];
    final levelData = PointsService.getLevelInfo(currentLevel);
    final progress = levelInfo['progress'];
    final pointsNeeded = levelInfo['points_needed'];
    final isMaxLevel = levelInfo['is_max_level'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card de pontos atuais
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.gradienteVeroPreco,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.azulVeroPreco.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.stars,
                  size: 48,
                  color: AppColors.branco,
                ),
                const SizedBox(height: 16),
                Text(
                  '${user.pontos} pontos',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.branco,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  levelData['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.branco,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Progresso do nível
          if (!isMaxLevel) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.branco,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cinzaClaro.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progresso do Nível',
                        style: AppStyles.subtitulo,
                      ),
                      Text(
                        'Nível ${levelInfo['next_level']}',
                        style: AppStyles.corpoPequeno,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.cinzaClaro,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(levelData['color']),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Faltam $pointsNeeded pontos para o próximo nível',
                    style: AppStyles.corpoPequeno,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Estatísticas
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.branco,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cinzaClaro.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suas Estatísticas',
                  style: AppStyles.subtitulo,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Ganho',
                        '${_userStats!['total_earned']}',
                        Icons.trending_up,
                        AppColors.sucesso,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Gasto',
                        '${_userStats!['total_spent']}',
                        Icons.shopping_cart,
                        AppColors.aviso,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Ações',
                        '${_userStats!['history_count']}',
                        Icons.assignment_turned_in,
                        AppColors.azulVeroPreco,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Nível',
                        '$currentLevel',
                        Icons.emoji_events,
                        Color(levelData['color']),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Como ganhar pontos
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.branco,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cinzaClaro.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Como Ganhar Pontos',
                  style: AppStyles.subtitulo,
                ),
                const SizedBox(height: 16),
                ...PointsService.POINTS_PER_ACTION.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.azulVeroPreco.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              '+${entry.value}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.azulVeroPreco,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            PointsService.getActionDescription(entry.key),
                            style: AppStyles.corpo,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppStyles.corpoPequeno,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recompensas Disponíveis',
            style: AppStyles.titulo,
          ),
          const SizedBox(height: 8),
          const Text(
            'Troque seus pontos por recompensas incríveis!',
            style: AppStyles.corpoPequeno,
          ),
          const SizedBox(height: 24),
          
          ..._availableRewards.map((reward) {
            final canAfford = reward['can_afford'] as bool;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.branco,
                borderRadius: BorderRadius.circular(12),
                border: canAfford
                    ? Border.all(color: AppColors.sucesso, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cinzaClaro.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(reward['color']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    reward['icon'],
                    color: Color(reward['color']),
                    size: 24,
                  ),
                ),
                title: Text(
                  reward['name'],
                  style: AppStyles.subtitulo,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      reward['description'],
                      style: AppStyles.corpo,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: 16,
                          color: canAfford ? AppColors.sucesso : AppColors.cinzaEscuro,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward['points_cost']} pontos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: canAfford ? AppColors.sucesso : AppColors.cinzaEscuro,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: canAfford
                      ? () => _redeemReward(reward['id'])
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford ? AppColors.sucesso : AppColors.cinzaClaro,
                    foregroundColor: AppColors.branco,
                  ),
                  child: Text(canAfford ? 'Resgatar' : 'Insuficiente'),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ranking de Pontos',
            style: AppStyles.titulo,
          ),
          const SizedBox(height: 8),
          const Text(
            'Veja quem está economizando mais!',
            style: AppStyles.corpoPequeno,
          ),
          const SizedBox(height: 24),
          
          ..._leaderboard.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            final isCurrentUser = AuthService.currentUser?.id == user['id'];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? AppColors.azulVeroPreco.withOpacity(0.1)
                    : AppColors.branco,
                borderRadius: BorderRadius.circular(12),
                border: isCurrentUser
                    ? Border.all(color: AppColors.azulVeroPreco, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cinzaClaro.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Posição
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getRankColor(index),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.branco,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Avatar
                  CircleAvatar(
                    backgroundColor: AppColors.azulVeroPreco.withOpacity(0.2),
                    child: Text(
                      user['nome_completo'][0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.azulVeroPreco,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Nome e pontos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['nome_completo'],
                          style: AppStyles.subtitulo.copyWith(
                            color: isCurrentUser ? AppColors.azulVeroPreco : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.stars,
                              size: 16,
                              color: AppColors.laranjaAcai,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${user['pontos']} pontos',
                              style: AppStyles.corpo.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Badge para usuário atual
                  if (isCurrentUser)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.azulVeroPreco,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Você',
                        style: TextStyle(
                          color: AppColors.branco,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Ouro
      case 1:
        return const Color(0xFFC0C0C0); // Prata
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.cinzaEscuro;
    }
  }
}

