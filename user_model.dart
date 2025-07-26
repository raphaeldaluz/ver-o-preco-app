class User {
  final int? id;
  final String nomeCompleto;
  final String email;
  final String telefone;
  final String cpf;
  final String senha;
  final int pontos;
  final DateTime dataCadastro;
  final DateTime? dataUltimoLogin;

  User({
    this.id,
    required this.nomeCompleto,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
    this.pontos = 0,
    required this.dataCadastro,
    this.dataUltimoLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_completo': nomeCompleto,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'senha': senha,
      'pontos': pontos,
      'data_cadastro': dataCadastro.millisecondsSinceEpoch,
      'data_ultimo_login': dataUltimoLogin?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      nomeCompleto: map['nome_completo'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      cpf: map['cpf'] ?? '',
      senha: map['senha'] ?? '',
      pontos: map['pontos']?.toInt() ?? 0,
      dataCadastro: DateTime.fromMillisecondsSinceEpoch(map['data_cadastro']),
      dataUltimoLogin: map['data_ultimo_login'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['data_ultimo_login'])
          : null,
    );
  }

  User copyWith({
    int? id,
    String? nomeCompleto,
    String? email,
    String? telefone,
    String? cpf,
    String? senha,
    int? pontos,
    DateTime? dataCadastro,
    DateTime? dataUltimoLogin,
  }) {
    return User(
      id: id ?? this.id,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      senha: senha ?? this.senha,
      pontos: pontos ?? this.pontos,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataUltimoLogin: dataUltimoLogin ?? this.dataUltimoLogin,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, nomeCompleto: $nomeCompleto, email: $email, telefone: $telefone, cpf: $cpf, pontos: $pontos, dataCadastro: $dataCadastro, dataUltimoLogin: $dataUltimoLogin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.nomeCompleto == nomeCompleto &&
        other.email == email &&
        other.telefone == telefone &&
        other.cpf == cpf &&
        other.senha == senha &&
        other.pontos == pontos &&
        other.dataCadastro == dataCadastro &&
        other.dataUltimoLogin == dataUltimoLogin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nomeCompleto.hashCode ^
        email.hashCode ^
        telefone.hashCode ^
        cpf.hashCode ^
        senha.hashCode ^
        pontos.hashCode ^
        dataCadastro.hashCode ^
        dataUltimoLogin.hashCode;
  }

  // Métodos utilitários
  String get primeiroNome {
    return nomeCompleto.split(' ').first;
  }

  String get cpfFormatado {
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
    }
    return cpf;
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

  bool get isEmailValido {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  bool get isCpfValido {
    final digits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 11;
  }

  bool get isTelefoneValido {
    final digits = telefone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 10;
  }
}

