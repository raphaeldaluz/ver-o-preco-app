import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/scanner_service.dart';

class BarcodeResultScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const BarcodeResultScreen({
    super.key,
    required this.productData,
  });

  @override
  State<BarcodeResultScreen> createState() => _BarcodeResultScreenState();
}

class _BarcodeResultScreenState extends State<BarcodeResultScreen> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final nome = widget.productData['nome']?.toString() ?? '';
    final marca = widget.productData['marca']?.toString() ?? '';
    final categoria = widget.productData['categoria']?.toString() ?? '';
    final imagem = widget.productData['imagem']?.toString() ?? '';
    final precos = widget.productData['precos'] as List<Map<String, dynamic>>? ?? [];
    
    final melhorSupermercado = ScannerService.getMelhorPreco(precos);
    final economia = ScannerService.calcularEconomia(precos);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecundario,
      appBar: AppBar(
        backgroundColor: AppColors.azulVeroPreco,
        title: const Text(
          'Comparação de Preços',
          style: TextStyle(color: AppColors.branco),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.branco),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.star : Icons.star_border,
              color: _isFavorited ? AppColors.laranjaTucuma : AppColors.branco,
            ),
            onPressed: () {
              setState(() {
                _isFavorited = !_isFavorited;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorited 
                        ? 'Produto favoritado! Você receberá notificações de desconto.'
                        : 'Produto removido dos favoritos.',
                  ),
                  backgroundColor: _isFavorited ? AppColors.sucesso : AppColors.textoSecundario,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card do produto
            Container(
              color: AppColors.backgroundPrimario,
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Row(
                children: [
                  // Imagem do produto
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.cinzaClaro,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: imagem,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.shopping_basket,
                          size: 40,
                          color: AppColors.textoSecundario,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Informações do produto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome,
                          style: AppStyles.subtitulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          marca,
                          style: AppStyles.corpoPequeno.copyWith(
                            color: AppColors.azulVeroPreco,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cinzaClaro,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            categoria,
                            style: AppStyles.corpoPequeno,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Card de economia
            if (economia > 0)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.laranjaTucuma, Color(0xFFFFB347)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.savings,
                      color: AppColors.branco,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Economia Disponível',
                            style: TextStyle(
                              color: AppColors.branco,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Você pode economizar até ${economia.toStringAsFixed(1)}% comprando no $melhorSupermercado',
                            style: const TextStyle(
                              color: AppColors.branco,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // Lista de preços
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preços nos Supermercados',
                    style: AppStyles.subtitulo,
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: precos.length,
                    itemBuilder: (context, index) {
                      final preco = precos[index];
                      final isLowest = preco['supermercado'] == melhorSupermercado;
                      
                      return _buildPriceCard(preco, isLowest);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botões de ação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _adicionarALista(context);
                      },
                      style: AppStyles.botaoPrimario,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Adicionar à Lista'),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _compartilhar(context);
                      },
                      style: AppStyles.botaoSecundario,
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar Preços'),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(Map<String, dynamic> preco, bool isLowest) {
    final supermercado = preco['supermercado']?.toString() ?? '';
    final valor = preco['preco'] as double? ?? 0.0;
    final desconto = preco['desconto'] as int? ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLowest ? AppColors.verdeAmazonia : AppColors.bordaPrimaria,
          width: isLowest ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícone do supermercado
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isLowest 
                  ? AppColors.verdeAmazonia.withOpacity(0.1)
                  : AppColors.cinzaClaro,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              isLowest ? Icons.store : Icons.store_outlined,
              color: isLowest ? AppColors.verdeAmazonia : AppColors.textoSecundario,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Informações do supermercado
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      supermercado,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isLowest ? AppColors.verdeAmazonia : AppColors.textoPrimario,
                      ),
                    ),
                    if (isLowest) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.verdeAmazonia,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'MELHOR PREÇO',
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (desconto > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Desconto de $desconto%',
                    style: AppStyles.corpoPequeno.copyWith(
                      color: AppColors.laranjaTucuma,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Preço
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${valor.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isLowest ? AppColors.verdeAmazonia : AppColors.textoPrimario,
                ),
              ),
              if (desconto > 0) ...[
                const SizedBox(height: 2),
                Text(
                  'R\$ ${(valor / (1 - desconto / 100)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _adicionarALista(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Adicionar à Lista',
              style: AppStyles.subtitulo,
            ),
            const SizedBox(height: 16),
            const Text(
              'Escolha em qual lista deseja adicionar este produto:',
              style: AppStyles.corpo,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Compras da Semana'),
              subtitle: const Text('12 itens'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto adicionado à lista!'),
                    backgroundColor: AppColors.sucesso,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Nova Lista'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar criação de nova lista
              },
            ),
          ],
        ),
      ),
    );
  }

  void _compartilhar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de compartilhamento em desenvolvimento'),
      ),
    );
  }
}

