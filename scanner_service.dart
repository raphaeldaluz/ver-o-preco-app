import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerService {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<String?> scanQRCode() async {
    try {
      // Verificar permissão da câmera
      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        throw Exception('Permissão da câmera negada');
      }

      // Simular scan de QR Code (aqui seria a integração real)
      await Future.delayed(const Duration(seconds: 2));
      
      // Retornar dados simulados de uma nota fiscal
      return '''
{
  "nfe": {
    "infNFe": {
      "ide": {
        "nNF": "123456",
        "dhEmi": "2025-01-26T10:30:00-03:00"
      },
      "emit": {
        "xNome": "Supermercado Pará Ltda",
        "CNPJ": "12.345.678/0001-90"
      },
      "det": [
        {
          "prod": {
            "cProd": "7891000100103",
            "xProd": "Arroz Tio João 1kg",
            "vUnCom": "4.99",
            "qCom": "2"
          }
        },
        {
          "prod": {
            "cProd": "7891000200204",
            "xProd": "Feijão Carioca 1kg",
            "vUnCom": "6.50",
            "qCom": "1"
          }
        }
      ],
      "total": {
        "ICMSTot": {
          "vNF": "16.48"
        }
      }
    }
  }
}
      ''';
    } catch (e) {
      debugPrint('Erro ao escanear QR Code: $e');
      return null;
    }
  }

  static Future<String?> scanBarcode() async {
    try {
      // Verificar permissão da câmera
      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        throw Exception('Permissão da câmera negada');
      }

      // Simular scan de código de barras
      await Future.delayed(const Duration(seconds: 2));
      
      // Retornar código de barras simulado
      final barcodes = [
        '7891000100103', // Arroz Tio João
        '7891000200204', // Feijão Carioca
        '7891000300305', // Açúcar Cristal
        '7891000400406', // Óleo de Soja
        '7891000500507', // Macarrão Galo
      ];
      
      // Retornar um código aleatório
      return barcodes[(DateTime.now().millisecond % barcodes.length)];
    } catch (e) {
      debugPrint('Erro ao escanear código de barras: $e');
      return null;
    }
  }

  static Map<String, dynamic> parseNFe(String nfeJson) {
    try {
      // Aqui seria a implementação real de parsing da NFe
      // Por enquanto, retornamos dados simulados
      return {
        'numero': '123456',
        'data': '26/01/2025',
        'estabelecimento': 'Supermercado Pará Ltda',
        'cnpj': '12.345.678/0001-90',
        'total': 16.48,
        'produtos': [
          {
            'codigo': '7891000100103',
            'nome': 'Arroz Tio João 1kg',
            'preco': 4.99,
            'quantidade': 2,
          },
          {
            'codigo': '7891000200204',
            'nome': 'Feijão Carioca 1kg',
            'preco': 6.50,
            'quantidade': 1,
          },
        ],
      };
    } catch (e) {
      debugPrint('Erro ao fazer parse da NFe: $e');
      return {};
    }
  }

  static Future<Map<String, dynamic>?> getProductInfo(String barcode) async {
    try {
      // Simular busca de informações do produto
      await Future.delayed(const Duration(seconds: 1));
      
      // Base de dados simulada
      final products = {
        '7891000100103': {
          'nome': 'Arroz Tio João 1kg',
          'marca': 'Tio João',
          'categoria': 'Grãos e Cereais',
          'imagem': 'https://via.placeholder.com/200x200?text=Arroz',
          'precos': [
            {
              'supermercado': 'Supermercado Pará',
              'preco': 4.99,
              'desconto': 0,
            },
            {
              'supermercado': 'Mercado Amazônia',
              'preco': 5.20,
              'desconto': 10,
            },
            {
              'supermercado': 'Hiper Belém',
              'preco': 4.85,
              'desconto': 15,
            },
          ],
        },
        '7891000200204': {
          'nome': 'Feijão Carioca 1kg',
          'marca': 'Camil',
          'categoria': 'Grãos e Cereais',
          'imagem': 'https://via.placeholder.com/200x200?text=Feijão',
          'precos': [
            {
              'supermercado': 'Supermercado Pará',
              'preco': 6.50,
              'desconto': 0,
            },
            {
              'supermercado': 'Mercado Amazônia',
              'preco': 6.20,
              'desconto': 5,
            },
            {
              'supermercado': 'Hiper Belém',
              'preco': 5.99,
              'desconto': 8,
            },
          ],
        },
        '7891000300305': {
          'nome': 'Açúcar Cristal 1kg',
          'marca': 'União',
          'categoria': 'Açúcar e Adoçantes',
          'imagem': 'https://via.placeholder.com/200x200?text=Açúcar',
          'precos': [
            {
              'supermercado': 'Supermercado Pará',
              'preco': 3.20,
              'desconto': 20,
            },
            {
              'supermercado': 'Mercado Amazônia',
              'preco': 3.50,
              'desconto': 0,
            },
            {
              'supermercado': 'Hiper Belém',
              'preco': 3.10,
              'desconto': 12,
            },
          ],
        },
      };
      
      return products[barcode];
    } catch (e) {
      debugPrint('Erro ao buscar informações do produto: $e');
      return null;
    }
  }

  static String getMelhorPreco(List<Map<String, dynamic>> precos) {
    if (precos.isEmpty) return '';
    
    double menorPreco = double.infinity;
    String melhorSupermercado = '';
    
    for (final preco in precos) {
      final valor = preco['preco'] as double;
      if (valor < menorPreco) {
        menorPreco = valor;
        melhorSupermercado = preco['supermercado'] as String;
      }
    }
    
    return melhorSupermercado;
  }

  static double calcularEconomia(List<Map<String, dynamic>> precos) {
    if (precos.length < 2) return 0;
    
    precos.sort((a, b) => (a['preco'] as double).compareTo(b['preco'] as double));
    
    final menorPreco = precos.first['preco'] as double;
    final maiorPreco = precos.last['preco'] as double;
    
    return ((maiorPreco - menorPreco) / maiorPreco * 100);
  }
}

