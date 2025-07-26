import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class ListsTab extends StatefulWidget {
  const ListsTab({super.key});

  @override
  State<ListsTab> createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  final List<Map<String, dynamic>> _shoppingLists = [
    {
      'id': 1,
      'name': 'Compras da Semana',
      'items': 12,
      'completed': 8,
      'date': '25/01/2025',
      'total': 'R\$ 89,50',
    },
    {
      'id': 2,
      'name': 'Festa de Aniversário',
      'items': 8,
      'completed': 3,
      'date': '20/01/2025',
      'total': 'R\$ 156,30',
    },
    {
      'id': 3,
      'name': 'Produtos de Limpeza',
      'items': 6,
      'completed': 6,
      'date': '18/01/2025',
      'total': 'R\$ 45,80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecundario,
      appBar: AppBar(
        backgroundColor: AppColors.azulVeroPreco,
        title: const Text(
          'Minhas Listas',
          style: TextStyle(color: AppColors.branco),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showCreateListDialog(context);
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.branco,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header com estatísticas
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Listas Ativas',
                      '${_shoppingLists.where((list) => list['completed'] < list['items']).length}',
                      Icons.list_alt,
                      AppColors.azulVeroPreco,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Itens Pendentes',
                        '${_shoppingLists.fold<int>(0, (sum, list) => sum + ((list['items'] as int) - (list['completed'] as int)))}',
                      Icons.shopping_cart,
                      AppColors.laranjaTucuma,
                    ),
                  ),
                ],
              ),
            ),
            
            // Lista de compras
            Expanded(
              child: _shoppingLists.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _shoppingLists.length,
                      itemBuilder: (context, index) {
                        return _buildListCard(_shoppingLists[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateListDialog(context);
        },
        backgroundColor: AppColors.laranjaTucuma,
        icon: const Icon(Icons.add, color: AppColors.branco),
        label: const Text(
          'Nova Lista',
          style: TextStyle(color: AppColors.branco),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: AppStyles.corpoPequeno,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildListCard(Map<String, dynamic> list) {
    final progress = list['completed'] / list['items'];
    final isCompleted = list['completed'] == list['items'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppStyles.cardDecoration,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted 
                ? AppColors.verdeAmazonia.withOpacity(0.1)
                : AppColors.azulVeroPreco.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.list_alt,
            color: isCompleted ? AppColors.verdeAmazonia : AppColors.azulVeroPreco,
            size: 28,
          ),
        ),
        title: Text(
          list['name'],
          style: AppStyles.subtitulo.copyWith(fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${list['completed']}/${list['items']} itens',
                  style: AppStyles.corpoPequeno,
                ),
                const SizedBox(width: 16),
                Text(
                  list['date'],
                  style: AppStyles.corpoPequeno,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Barra de progresso
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bordaPrimaria,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? AppColors.verdeAmazonia : AppColors.azulVeroPreco,
              ),
            ),
            
            const SizedBox(height: 8),
            Text(
              'Total estimado: ${list['total']}',
              style: AppStyles.preco.copyWith(fontSize: 14),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20),
                  SizedBox(width: 8),
                  Text('Duplicar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.erro),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: AppColors.erro)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            _handleListAction(value.toString(), list);
          },
        ),
        onTap: () {
          _openListDetails(list);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt_outlined,
              size: 80,
              color: AppColors.textoSecundario.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma lista criada',
              style: AppStyles.subtitulo,
            ),
            const SizedBox(height: 8),
            const Text(
              'Crie sua primeira lista de compras para começar a economizar',
              style: AppStyles.corpoPequeno,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showCreateListDialog(context);
              },
              style: AppStyles.botaoPrimario,
              icon: const Icon(Icons.add),
              label: const Text('Criar Lista'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Lista de Compras'),
        content: TextField(
          controller: nameController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Nome da lista',
            hintText: 'Ex: Compras da semana',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _shoppingLists.add({
                    'id': _shoppingLists.length + 1,
                    'name': nameController.text,
                    'items': 0,
                    'completed': 0,
                    'date': '26/01/2025',
                    'total': 'R\$ 0,00',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lista criada com sucesso!'),
                    backgroundColor: AppColors.sucesso,
                  ),
                );
              }
            },
            style: AppStyles.botaoPrimario,
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _handleListAction(String action, Map<String, dynamic> list) {
    switch (action) {
      case 'edit':
        // TODO: Implementar edição
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
        );
        break;
      case 'duplicate':
        setState(() {
          _shoppingLists.add({
            ...list,
            'id': _shoppingLists.length + 1,
            'name': '${list['name']} (Cópia)',
            'completed': 0,
            'date': '26/01/2025',
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista duplicada com sucesso!'),
            backgroundColor: AppColors.sucesso,
          ),
        );
        break;
      case 'delete':
        setState(() {
          _shoppingLists.remove(list);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista excluída'),
            backgroundColor: AppColors.erro,
          ),
        );
        break;
    }
  }

  void _openListDetails(Map<String, dynamic> list) {
    // TODO: Navegar para tela de detalhes da lista
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrindo lista: ${list['name']}')),
    );
  }
}

