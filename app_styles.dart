import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Estilos de Texto
  static const TextStyle titulo = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textoPrimario,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle subtitulo = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textoPrimario,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle corpo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textoPrimario,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle corpoPequeno = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textoSecundario,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle botao = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textoClaro,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle preco = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.verdeAmazonia,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle precoDesconto = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.laranjaTucuma,
    fontFamily: 'Roboto',
  );
  
  // Estilos de Card
  static const BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.backgroundCard,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // Estilos de Botão
  static final ButtonStyle botaoPrimario = ElevatedButton.styleFrom(
    backgroundColor: AppColors.botaoPrimario,
    foregroundColor: AppColors.textoClaro,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 2,
  );
  
  static final ButtonStyle botaoSecundario = OutlinedButton.styleFrom(
    foregroundColor: AppColors.azulVeroPreco,
    side: const BorderSide(color: AppColors.azulVeroPreco),
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static final ButtonStyle botaoDestaque = ElevatedButton.styleFrom(
    backgroundColor: AppColors.botaoDestaque,
    foregroundColor: AppColors.textoClaro,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 2,
  );
  
  // Estilos de Input
  static final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.bordaPrimaria),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.bordaPrimaria),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.azulVeroPreco, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.erro),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    fillColor: AppColors.backgroundPrimario,
    filled: true,
  );
}

class AppDimensions {
  // Padding e Margin
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Espaçamento entre elementos
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;
  
  // Bordas arredondadas
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  // Tamanhos de ícones
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  
  // Altura de componentes
  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double cardMinHeight = 80.0;
  
  // Largura mínima para touch targets
  static const double minTouchTarget = 44.0;
}

