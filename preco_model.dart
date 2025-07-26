class Preco {
  final int? id;
  final String produtoCodigo;
  final int supermercadoId;
  final double preco;
  final double? precoPromocional;
  final int? descontoPercentual;
  final DateTime? inicioPromocao;
  final DateTime? fimPromocao;
  final bool disponivel;
  final DateTime dataAtualizacao;
  final String? observacoes;

  // Campos relacionados (não salvos no banco)
  final String? produtoNome;
  final String? supermercadoNome;

  Preco({
    this.id,
    required this.produtoCodigo,
    required this.supermercadoId,
    required this.preco,
    this.precoPromocional,
    this.descontoPercentual,
    this.inicioPromocao,
    this.fimPromocao,
    this.disponivel = true,
    required this.dataAtualizacao,
    this.observacoes,
    this.produtoNome,
    this.supermercadoNome,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto_codigo': produtoCodigo,
      'supermercado_id': supermercadoId,
      'preco': preco,
      'preco_promocional': precoPromocional,
      'desconto_percentual': descontoPercentual,
      'inicio_promocao': inicioPromocao?.millisecondsSinceEpoch,
      'fim_promocao': fimPromocao?.millisecondsSinceEpoch,
      'disponivel': disponivel ? 1 : 0,
      'data_atualizacao': dataAtualizacao.millisecondsSinceEpoch,
      'observacoes': observacoes,
    };
  }

  factory Preco.fromMap(Map<String, dynamic> map) {
    return Preco(
      id: map['id']?.toInt(),
      produtoCodigo: map['produto_codigo'] ?? '',
      supermercadoId: map['supermercado_id']?.toInt() ?? 0,
      preco: map['preco']?.toDouble() ?? 0.0,
      precoPromocional: map['preco_promocional']?.toDouble(),
      descontoPercentual: map['desconto_percentual']?.toInt(),
      inicioPromocao: map['inicio_promocao'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['inicio_promocao'])
          : null,
      fimPromocao: map['fim_promocao'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fim_promocao'])
          : null,
      disponivel: (map['disponivel'] ?? 1) == 1,
      dataAtualizacao: DateTime.fromMillisecondsSinceEpoch(map['data_atualizacao']),
      observacoes: map['observacoes'],
      produtoNome: map['produto_nome'],
      supermercadoNome: map['supermercado_nome'],
    );
  }

  Preco copyWith({
    int? id,
    String? produtoCodigo,
    int? supermercadoId,
    double? preco,
    double? precoPromocional,
    int? descontoPercentual,
    DateTime? inicioPromocao,
    DateTime? fimPromocao,
    bool? disponivel,
    DateTime? dataAtualizacao,
    String? observacoes,
    String? produtoNome,
    String? supermercadoNome,
  }) {
    return Preco(
      id: id ?? this.id,
      produtoCodigo: produtoCodigo ?? this.produtoCodigo,
      supermercadoId: supermercadoId ?? this.supermercadoId,
      preco: preco ?? this.preco,
      precoPromocional: precoPromocional ?? this.precoPromocional,
      descontoPercentual: descontoPercentual ?? this.descontoPercentual,
      inicioPromocao: inicioPromocao ?? this.inicioPromocao,
      fimPromocao: fimPromocao ?? this.fimPromocao,
      disponivel: disponivel ?? this.disponivel,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      observacoes: observacoes ?? this.observacoes,
      produtoNome: produtoNome ?? this.produtoNome,
      supermercadoNome: supermercadoNome ?? this.supermercadoNome,
    );
  }

  @override
  String toString() {
    return 'Preco(id: $id, produtoCodigo: $produtoCodigo, supermercadoId: $supermercadoId, preco: $preco, precoPromocional: $precoPromocional, descontoPercentual: $descontoPercentual, inicioPromocao: $inicioPromocao, fimPromocao: $fimPromocao, disponivel: $disponivel, dataAtualizacao: $dataAtualizacao, observacoes: $observacoes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Preco &&
        other.id == id &&
        other.produtoCodigo == produtoCodigo &&
        other.supermercadoId == supermercadoId &&
        other.preco == preco &&
        other.precoPromocional == precoPromocional &&
        other.descontoPercentual == descontoPercentual &&
        other.inicioPromocao == inicioPromocao &&
        other.fimPromocao == fimPromocao &&
        other.disponivel == disponivel &&
        other.dataAtualizacao == dataAtualizacao &&
        other.observacoes == observacoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        produtoCodigo.hashCode ^
        supermercadoId.hashCode ^
        preco.hashCode ^
        precoPromocional.hashCode ^
        descontoPercentual.hashCode ^
        inicioPromocao.hashCode ^
        fimPromocao.hashCode ^
        disponivel.hashCode ^
        dataAtualizacao.hashCode ^
        observacoes.hashCode;
  }

  // Métodos utilitários
  double get precoFinal {
    if (isPromocaoAtiva && precoPromocional != null) {
      return precoPromocional!;
    }
    return preco;
  }

  bool get isPromocaoAtiva {
    if (precoPromocional == null) return false;
    
    final agora = DateTime.now();
    
    // Se não tem data de início, considera que a promoção está ativa
    if (inicioPromocao != null && agora.isBefore(inicioPromocao!)) {
      return false;
    }
    
    // Se tem data de fim e já passou, promoção não está ativa
    if (fimPromocao != null && agora.isAfter(fimPromocao!)) {
      return false;
    }
    
    return true;
  }

  double get economiaReais {
    if (!isPromocaoAtiva || precoPromocional == null) return 0.0;
    return preco - precoPromocional!;
  }

  double get economiaPercentual {
    if (!isPromocaoAtiva || precoPromocional == null) return 0.0;
    return ((preco - precoPromocional!) / preco) * 100;
  }

  String get precoFormatado {
    return 'R\$ ${precoFinal.toStringAsFixed(2)}';
  }

  String get precoOriginalFormatado {
    return 'R\$ ${preco.toStringAsFixed(2)}';
  }

  String get economiaFormatada {
    if (!isPromocaoAtiva) return '';
    return 'Economize R\$ ${economiaReais.toStringAsFixed(2)} (${economiaPercentual.toStringAsFixed(1)}%)';
  }

  bool get isPrecoAntigo {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataAtualizacao);
    return diferenca.inDays > 7; // Considera preço antigo se tem mais de 7 dias
  }

  String get statusAtualizacao {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataAtualizacao);
    
    if (diferenca.inMinutes < 60) {
      return 'Atualizado há ${diferenca.inMinutes} min';
    } else if (diferenca.inHours < 24) {
      return 'Atualizado há ${diferenca.inHours}h';
    } else {
      return 'Atualizado há ${diferenca.inDays} dias';
    }
  }
}

