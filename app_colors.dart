import 'package:flutter/material.dart';

class AppColors {
  // Cores Primárias
  static const Color azulVeroPreco = Color(0xFF2E5C8A); // Azul Ver-o-Peso
  static const Color verdeAmazonia = Color(0xFF228B22); // Verde Amazônia
  static const Color laranjaTucuma = Color(0xFFFF8C00); // Laranja Tucumã
  static const Color laranjaAcai = Color(0xFFFF6F00); // Laranja Açaí
  
  // Cores Secundárias
  static const Color branco = Color(0xFFFFFFFF);
  static const Color cinzaClaro = Color(0xFFF5F5F5);
  static const Color cinzaEscuro = Color(0xFF333333);
  static const Color verdeClaro = Color(0xFF90EE90);
  static const Color vermelhoSuave = Color(0xFFFF6B6B);
  
  // Cores de Estado
  static const Color sucesso = verdeClaro;
  static const Color erro = vermelhoSuave;
  static const Color aviso = laranjaTucuma;
  static const Color info = azulVeroPreco;
  
  // Cores de Texto
  static const Color textoPrimario = cinzaEscuro;
  static const Color textoSecundario = Color(0xFF666666);
  static const Color textoClaro = branco;
  
  // Cores de Background
  static const Color backgroundPrimario = branco;
  static const Color backgroundSecundario = cinzaClaro;
  static const Color backgroundCard = branco;
  
  // Cores de Botão
  static const Color botaoPrimario = azulVeroPreco;
  static const Color botaoSecundario = Colors.transparent;
  static const Color botaoDestaque = laranjaTucuma;
  
  // Cores de Borda
  static const Color bordaPrimaria = Color(0xFFE0E0E0);
  static const Color bordaSecundaria = azulVeroPreco;
  
  // Gradientes
  static const LinearGradient gradienteAmazonico = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF87CEEB), // Céu amazônico
      Color(0xFF228B22), // Verde floresta
    ],
  );
  
  static const LinearGradient gradienteVeroPreco = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      azulVeroPreco,
      verdeAmazonia,
    ],
  );
}

