import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/scanner_service.dart';
import '../scanner/qr_result_screen.dart';
import '../scanner/barcode_result_screen.dart';

class ScannerTab extends StatelessWidget {
  const ScannerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimario,
      appBar: AppBar(
        backgroundColor: AppColors.azulVeroPreco,
        title: const Text(
          'Scanner',
          style: TextStyle(color: AppColors.branco),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone principal
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteVeroPreco,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 60,
                  color: AppColors.branco,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Título
              const Text(
                'Escolha o tipo de scan',
                style: AppStyles.titulo,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Descrição
              const Text(
                'Escaneie QR Code da nota fiscal para ganhar pontos ou código de barras para comparar preços',
                style: AppStyles.corpo,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Botões de scanner
              Column(
                children: [
                  // QR Code Scanner
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _scanQRCode(context);
                      },
                      style: AppStyles.botaoPrimario,
                      icon: const Icon(Icons.qr_code),
                      label: const Text('Escanear QR Code da Nota Fiscal'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Barcode Scanner
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _scanBarcode(context);
                      },
                      style: AppStyles.botaoDestaque,
                      icon: const Icon(Icons.barcode_reader),
                      label: const Text('Escanear Código de Barras'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Informações sobre pontos
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.verdeClaro.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.verdeAmazonia.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.verdeAmazonia,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ganhe pontos!',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.verdeAmazonia,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cada nota fiscal escaneada vale 10 pontos. Troque por recompensas!',
                            style: AppStyles.corpoPequeno.copyWith(
                              color: AppColors.verdeAmazonia,
                            ),
                          ),
                        ],
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

  Future<void> _scanQRCode(BuildContext context) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Escanear QR Code
      final result = await ScannerService.scanQRCode();
      
      // Fechar loading
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (result != null && context.mounted) {
        // Fazer parse da NFe
        final nfeData = ScannerService.parseNFe(result);
        
        // Navegar para tela de resultado
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRResultScreen(nfeData: nfeData),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível escanear o QR Code'),
            backgroundColor: AppColors.erro,
          ),
        );
      }
    } catch (e) {
      // Fechar loading se ainda estiver aberto
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppColors.erro,
          ),
        );
      }
    }
  }

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Escanear código de barras
      final barcode = await ScannerService.scanBarcode();
      
      if (barcode != null) {
        // Buscar informações do produto
        final productData = await ScannerService.getProductInfo(barcode);
        
        // Fechar loading
        if (context.mounted) {
          Navigator.pop(context);
        }

        if (productData != null && context.mounted) {
          // Navegar para tela de resultado
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarcodeResultScreen(productData: productData),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto não encontrado em nossa base de dados'),
              backgroundColor: AppColors.aviso,
            ),
          );
        }
      } else {
        // Fechar loading
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível escanear o código de barras'),
              backgroundColor: AppColors.erro,
            ),
          );
        }
      }
    } catch (e) {
      // Fechar loading se ainda estiver aberto
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppColors.erro,
          ),
        );
      }
    }
  }
}

