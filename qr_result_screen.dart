import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class QRResultScreen extends StatelessWidget {
  final Map<String, dynamic> nfeData;

  const QRResultScreen({
    super.key,
    required this.nfeData,
  });

  @override
  Widget build(BuildContext context) {
    final produtos = nfeData['produtos'] as List<Map<String, dynamic>>? ?? [];
    final total = nfeData['total'] as double? ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecundario,
      appBar: AppBar(
        backgroundColor: AppColors.azulVeroPreco,
        title: const Text(
          'Nota Fiscal Escaneada',
          style: TextStyle(color: AppColors.branco),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.branco),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de sucesso
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.verdeAmazonia, AppColors.verdeClaro],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.branco,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Parabéns!',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Você ganhou 10 pontos por escanear esta nota fiscal!',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.branco.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars,
                          color: AppColors.laranjaTucuma,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '+10 pontos',
                          style: TextStyle(
                            color: AppColors.branco,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Informações da nota fiscal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações da Nota Fiscal',
                    style: AppStyles.subtitulo,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoRow('Número:', nfeData['numero']?.toString() ?? '-'),
                  _buildInfoRow('Data:', nfeData['data']?.toString() ?? '-'),
                  _buildInfoRow('Estabelecimento:', nfeData['estabelecimento']?.toString() ?? '-'),
                  _buildInfoRow('CNPJ:', nfeData['cnpj']?.toString() ?? '-'),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total da Compra:',
                        style: AppStyles.subtitulo,
                      ),
                      Text(
                        'R\$ ${total.toStringAsFixed(2)}',
                        style: AppStyles.preco.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de produtos
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Produtos Escaneados',
                        style: AppStyles.subtitulo,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.azulVeroPreco.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${produtos.length} itens',
                          style: const TextStyle(
                            color: AppColors.azulVeroPreco,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: produtos.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final produto = produtos[index];
                      return _buildProductItem(produto);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botões de ação
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _adicionarALista(context);
                    },
                    style: AppStyles.botaoPrimario,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Adicionar à Lista de Compras'),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _compararPrecos(context);
                    },
                    style: AppStyles.botaoSecundario,
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Comparar Preços'),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Voltar ao Início'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppStyles.corpoPequeno.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyles.corpo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> produto) {
    final nome = produto['nome']?.toString() ?? '';
    final preco = produto['preco'] as double? ?? 0.0;
    final quantidade = produto['quantidade'] as int? ?? 0;
    final total = preco * quantidade;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Ícone do produto
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cinzaClaro,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_basket,
              color: AppColors.textoSecundario,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Informações do produto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qtd: $quantidade x R\$ ${preco.toStringAsFixed(2)}',
                  style: AppStyles.corpoPequeno,
                ),
              ],
            ),
          ),
          
          // Preço total
          Text(
            'R\$ ${total.toStringAsFixed(2)}',
            style: AppStyles.preco.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _adicionarALista(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produtos adicionados à lista de compras!'),
        backgroundColor: AppColors.sucesso,
      ),
    );
  }

  void _compararPrecos(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade em desenvolvimento'),
      ),
    );
  }
}

