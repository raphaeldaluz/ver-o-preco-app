class Supermercado {
  final int? id;
  final String nome;
  final String cnpj;
  final String endereco;
  final String telefone;
  final String? email;
  final String? website;
  final double latitude;
  final double longitude;
  final String logoUrl;
  final bool ativo;
  final DateTime dataCadastro;

  Supermercado({
    this.id,
    required this.nome,
    required this.cnpj,
    required this.endereco,
    required this.telefone,
    this.email,
    this.website,
    required this.latitude,
    required this.longitude,
    required this.logoUrl,
    this.ativo = true,
    required this.dataCadastro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'logo_url': logoUrl,
      'ativo': ativo ? 1 : 0,
      'data_cadastro': dataCadastro.millisecondsSinceEpoch,
    };
  }

  factory Supermercado.fromMap(Map<String, dynamic> map) {
    return Supermercado(
      id: map['id']?.toInt(),
      nome: map['nome'] ?? '',
      cnpj: map['cnpj'] ?? '',
      endereco: map['endereco'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'],
      website: map['website'],
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      logoUrl: map['logo_url'] ?? '',
      ativo: (map['ativo'] ?? 1) == 1,
      dataCadastro: DateTime.fromMillisecondsSinceEpoch(map['data_cadastro']),
    );
  }

  Supermercado copyWith({
    int? id,
    String? nome,
    String? cnpj,
    String? endereco,
    String? telefone,
    String? email,
    String? website,
    double? latitude,
    double? longitude,
    String? logoUrl,
    bool? ativo,
    DateTime? dataCadastro,
  }) {
    return Supermercado(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      endereco: endereco ?? this.endereco,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      website: website ?? this.website,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      logoUrl: logoUrl ?? this.logoUrl,
      ativo: ativo ?? this.ativo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }

  @override
  String toString() {
    return 'Supermercado(id: $id, nome: $nome, cnpj: $cnpj, endereco: $endereco, telefone: $telefone, email: $email, website: $website, latitude: $latitude, longitude: $longitude, logoUrl: $logoUrl, ativo: $ativo, dataCadastro: $dataCadastro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Supermercado &&
        other.id == id &&
        other.nome == nome &&
        other.cnpj == cnpj &&
        other.endereco == endereco &&
        other.telefone == telefone &&
        other.email == email &&
        other.website == website &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.logoUrl == logoUrl &&
        other.ativo == ativo &&
        other.dataCadastro == dataCadastro;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        cnpj.hashCode ^
        endereco.hashCode ^
        telefone.hashCode ^
        email.hashCode ^
        website.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        logoUrl.hashCode ^
        ativo.hashCode ^
        dataCadastro.hashCode;
  }

  // Métodos utilitários
  String get cnpjFormatado {
    if (cnpj.length == 14) {
      return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}';
    }
    return cnpj;
  }

  String get telefoneFormatado {
    final digits = telefone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    } else if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6, 10)}';
    }
    return telefone;
  }

  String get enderecoResumido {
    final partes = endereco.split(',');
    if (partes.length >= 2) {
      return '${partes[0].trim()}, ${partes[1].trim()}';
    }
    return endereco;
  }
}

