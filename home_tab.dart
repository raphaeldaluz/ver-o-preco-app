import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecundario,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com gradiente
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.gradienteVeroPreco,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Olá, João!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.branco,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Bem-vindo ao Ver-o-Preço',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.branco.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.branco.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: AppColors.branco,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
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
                          children: [
                            const Icon(
                              Icons.stars,
                              color: AppColors.laranjaTucuma,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Seus Pontos',
                                    style: TextStyle(
                                      color: AppColors.branco,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    '1.250 pontos',
                                    style: TextStyle(
                                      color: AppColors.branco,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navegar para tela de recompensas
                              },
                              child: const Text(
                                'Trocar',
                                style: TextStyle(
                                  color: AppColors.branco,
                                  fontWeight: FontWeight.w600,
                                ),
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
              
              // Funcionalidades principais
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'O que você quer fazer?',
                      style: AppStyles.subtitulo,
                    ),
                    const SizedBox(height: 16),
                    
                    // Grid de funcionalidades
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        _buildFeatureCard(
                          icon: Icons.qr_code_scanner,
                          title: 'Escanear QR Code',
                          subtitle: 'Nota fiscal',
                          color: AppColors.azulVeroPreco,
                          onTap: () {
                            // TODO: Navegar para scanner QR
                          },
                        ),
                        _buildFeatureCard(
                          icon: Icons.barcode_reader,
                          title: 'Código de Barras',
                          subtitle: 'Produto',
                          color: AppColors.verdeAmazonia,
                          onTap: () {
                            // TODO: Navegar para scanner código de barras
                          },
                        ),
                        _buildFeatureCard(
                          icon: Icons.list_alt,
                          title: 'Lista de Compras',
                          subtitle: 'Criar nova',
                          color: AppColors.laranjaTucuma,
                          onTap: () {
                            // TODO: Navegar para criar lista
                          },
                        ),
                        _buildFeatureCard(
                          icon: Icons.trending_down,
                          title: 'Ofertas',
                          subtitle: 'Melhores preços',
                          color: AppColors.vermelhoSuave,
                          onTap: () {
                            // TODO: Navegar para ofertas
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Seção de produtos em destaque
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Produtos em Destaque',
                          style: AppStyles.subtitulo,
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Ver todos os produtos
                          },
                          child: const Text(
                            'Ver todos',
                            style: TextStyle(color: AppColors.azulVeroPreco),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Lista horizontal de produtos
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildProductCard(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppStyles.cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppStyles.corpoPequeno,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final products = [
      {'name': 'Arroz Tio João', 'price': 'R\$ 4,99', 'discount': '15%'},
      {'name': 'Feijão Carioca', 'price': 'R\$ 6,50', 'discount': '10%'},
      {'name': 'Açúcar Cristal', 'price': 'R\$ 3,20', 'discount': '20%'},
      {'name': 'Óleo de Soja', 'price': 'R\$ 5,80', 'discount': '8%'},
      {'name': 'Macarrão Galo', 'price': 'R\$ 2,99', 'discount': '12%'},
    ];

    final product = products[index];

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: AppStyles.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto (placeholder)
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cinzaClaro,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_basket,
                  color: AppColors.textoSecundario,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Nome do produto
            Text(
              product['name']!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),
            
            // Preço e desconto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product['price']!,
                  style: AppStyles.preco.copyWith(fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.laranjaTucuma,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${product['discount']!}',
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

