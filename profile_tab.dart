import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/auth_service.dart';
import '../points/points_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Usuário não encontrado'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundSecundario,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com informações do usuário
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.gradienteVeroPreco,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.branco,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.azulVeroPreco,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Nome do usuário
                      Text(
                        user.nomeCompleto,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.branco,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Email
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.branco.withOpacity(0.9),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Card de pontos
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.branco.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.branco.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Seus Pontos',
                                  style: TextStyle(
                                    color: AppColors.branco,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${user.pontos}',
                                  style: TextStyle(
                                    color: AppColors.branco,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.laranjaTucuma,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.stars,
                                color: AppColors.branco,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Menu de opções
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  children: [
                    // Seção Conta
                    _buildSectionTitle('Minha Conta'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.stars,
                        title: 'Pontos e Recompensas',
                        subtitle: '${user.pontos} pontos disponíveis',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PointsScreen(),
                            ),
                          );
                        },
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.laranjaAcai,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${user.pontos}',
                            style: const TextStyle(
                              color: AppColors.branco,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Editar Perfil',
                        subtitle: 'Alterar dados pessoais',
                        onTap: () => _showEditProfile(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        title: 'Alterar Senha',
                        subtitle: 'Trocar senha de acesso',
                        onTap: () => _showChangePassword(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications_none,
                        title: 'Notificações',
                        subtitle: 'Configurar alertas',
                        onTap: () => _showNotificationSettings(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // Seção Pontos e Recompensas
                    _buildSectionTitle('Pontos e Recompensas'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.star_border,
                        title: 'Minhas Recompensas',
                        subtitle: 'Ver recompensas disponíveis',
                        onTap: () => _showRewards(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: 'Histórico de Pontos',
                        subtitle: 'Ver ganhos e trocas',
                        onTap: () => _showPointsHistory(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // Seção Suporte
                    _buildSectionTitle('Suporte'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Central de Ajuda',
                        subtitle: 'Dúvidas frequentes',
                        onTap: () => _showHelp(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.feedback,
                        title: 'Enviar Feedback',
                        subtitle: 'Sugestões e melhorias',
                        onTap: () => _showFeedback(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'Sobre o App',
                        subtitle: 'Versão e informações',
                        onTap: () => _showAbout(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 32),
                    
                    // Botão de logout
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showLogoutDialog(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.erro,
                          side: const BorderSide(color: AppColors.erro),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Sair da Conta'),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppStyles.subtitulo,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.azulVeroPreco.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.azulVeroPreco,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppStyles.corpoPequeno,
      ),
      trailing: trailing ?? const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textoSecundario,
      ),
      onTap: onTap,
    );
  }

  void _showEditProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showChangePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showRewards(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showPointsHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o Ver-o-Preço'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versão: 1.0.0'),
            SizedBox(height: 8),
            Text('Desenvolvido com ❤️ para o Pará'),
            SizedBox(height: 8),
            Text('Tradição paraense em suas compras'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.erro,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

