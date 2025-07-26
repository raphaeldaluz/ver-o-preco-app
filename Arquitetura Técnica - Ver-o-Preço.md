# Arquitetura Técnica - Ver-o-Preço

Este documento descreve a arquitetura técnica do aplicativo Ver-o-Preço, incluindo padrões de design, estrutura de dados e decisões arquiteturais.

## 🏗️ Visão Geral da Arquitetura

O Ver-o-Preço segue uma arquitetura em camadas (Layered Architecture) com separação clara de responsabilidades:

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│         (Views & Widgets)           │
├─────────────────────────────────────┤
│           Service Layer             │
│        (Business Logic)             │
├─────────────────────────────────────┤
│            Data Layer               │
│      (Models & Database)            │
├─────────────────────────────────────┤
│          External Layer             │
│    (APIs, Sensors, Storage)         │
└─────────────────────────────────────┘
```

## 📁 Estrutura de Diretórios

```
lib/
├── constants/              # Constantes da aplicação
│   ├── app_colors.dart     # Paleta de cores
│   └── app_styles.dart     # Estilos e dimensões
├── models/                 # Modelos de dados
│   ├── user_model.dart     # Modelo do usuário
│   ├── produto_model.dart  # Modelo de produto
│   ├── preco_model.dart    # Modelo de preço
│   └── supermercado_model.dart # Modelo de supermercado
├── services/               # Camada de serviços
│   ├── auth_service.dart   # Autenticação
│   ├── database_service.dart # Banco de dados
│   ├── scanner_service.dart # Scanner QR/Barcode
│   ├── points_service.dart # Sistema de pontos
│   └── notification_service.dart # Notificações
├── views/                  # Interfaces do usuário
│   ├── auth/              # Telas de autenticação
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/              # Telas principais
│   │   ├── main_screen.dart
│   │   ├── home_tab.dart
│   │   ├── scanner_tab.dart
│   │   ├── lists_tab.dart
│   │   └── profile_tab.dart
│   ├── points/            # Sistema de pontos
│   │   └── points_screen.dart
│   └── scanner/           # Resultados de scan
│       ├── qr_result_screen.dart
│       └── barcode_result_screen.dart
└── main.dart              # Ponto de entrada
```

## 🎯 Padrões de Design Implementados

### 1. Service Layer Pattern
Toda a lógica de negócio está encapsulada em serviços:

```dart
class AuthService {
  static User? _currentUser;
  
  static Future<Map<String, dynamic>> login(String email, String password) {
    // Lógica de autenticação
  }
  
  static Future<Map<String, dynamic>> register(User user) {
    // Lógica de cadastro
  }
}
```

**Benefícios:**
- Separação clara entre UI e lógica de negócio
- Reutilização de código
- Facilita testes unitários
- Manutenibilidade

### 2. Singleton Pattern
Serviços críticos implementam Singleton para garantir instância única:

```dart
class DatabaseService {
  static Database? _database;
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

**Aplicado em:**
- DatabaseService
- AuthService
- NotificationService

### 3. Factory Pattern
Criação de objetos complexos através de factories:

```dart
class User {
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nomeCompleto: map['nome_completo'],
      email: map['email'],
      // ...
    );
  }
}
```

### 4. Observer Pattern
Sistema de notificações implementa Observer:

```dart
class NotificationService {
  static Future<void> notifyPointsEarned(int pontos, String motivo) {
    // Notifica observadores sobre pontos ganhos
  }
}
```

### 5. Strategy Pattern
Diferentes estratégias de scanner:

```dart
class ScannerService {
  static Future<String?> scanQRCode() {
    // Estratégia para QR Code
  }
  
  static Future<String?> scanBarcode() {
    // Estratégia para código de barras
  }
}
```

## 🗄️ Arquitetura de Dados

### Modelo Relacional SQLite

```sql
-- Usuários
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome_completo TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  telefone TEXT NOT NULL,
  cpf TEXT UNIQUE NOT NULL,
  senha_hash TEXT NOT NULL,
  pontos INTEGER DEFAULT 50,
  data_cadastro INTEGER NOT NULL,
  data_ultimo_login INTEGER
);

-- Supermercados
CREATE TABLE supermercados (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  endereco TEXT NOT NULL,
  telefone TEXT,
  cnpj TEXT UNIQUE NOT NULL,
  latitude REAL,
  longitude REAL
);

-- Produtos
CREATE TABLE produtos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  codigo_barras TEXT UNIQUE NOT NULL,
  nome TEXT NOT NULL,
  marca TEXT,
  categoria TEXT,
  descricao TEXT,
  imagem_url TEXT
);

-- Preços
CREATE TABLE precos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produto_id INTEGER NOT NULL,
  supermercado_id INTEGER NOT NULL,
  preco REAL NOT NULL,
  preco_promocional REAL,
  data_inicio_promocao INTEGER,
  data_fim_promocao INTEGER,
  data_atualizacao INTEGER NOT NULL,
  FOREIGN KEY (produto_id) REFERENCES produtos (id),
  FOREIGN KEY (supermercado_id) REFERENCES supermercados (id)
);

-- Favoritos
CREATE TABLE favoritos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  produto_codigo TEXT NOT NULL,
  data_criacao INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Histórico de Pontos
CREATE TABLE pontos_historico (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  points INTEGER NOT NULL,
  description TEXT,
  metadata TEXT,
  data_criacao INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
);
```

### Relacionamentos

```
Users (1) ←→ (N) Favoritos
Users (1) ←→ (N) PontosHistorico
Produtos (1) ←→ (N) Precos
Supermercados (1) ←→ (N) Precos
```

## 🔐 Arquitetura de Segurança

### Autenticação
```dart
class AuthService {
  // Hash SHA-256 para senhas
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Validação de CPF com algoritmo oficial
  static bool _isValidCPF(String cpf) {
    return CPFValidator.isValid(cpf);
  }
}
```

### Validações
- **CPF**: Algoritmo oficial brasileiro
- **Email**: Regex RFC 5322
- **Telefone**: Formato brasileiro
- **Senhas**: Hash SHA-256

### Armazenamento Seguro
```dart
class DatabaseService {
  // Dados sensíveis criptografados
  static Future<void> _initDatabase() async {
    // Configurações de segurança do SQLite
  }
}
```

## 📱 Arquitetura de Interface

### Padrão de Navegação
```dart
// Bottom Navigation com 4 tabs principais
class MainScreen extends StatefulWidget {
  final List<Widget> _tabs = [
    HomeTab(),
    ScannerTab(),
    ListsTab(),
    ProfileTab(),
  ];
}
```

### Gerenciamento de Estado
```dart
// StatefulWidget para componentes com estado
class PointsScreen extends StatefulWidget {
  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

// StatelessWidget para componentes estáticos
class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    // ...
  }
}
```

### Responsividade
```dart
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Breakpoints responsivos
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 768;
  }
}
```

## 🔄 Fluxo de Dados

### Fluxo de Autenticação
```
1. User Input → LoginScreen
2. LoginScreen → AuthService.login()
3. AuthService → DatabaseService.getUserByEmail()
4. DatabaseService → SQLite Query
5. SQLite → User Data
6. AuthService → Password Validation
7. AuthService → SharedPreferences (Session)
8. LoginScreen → MainScreen (Navigation)
```

### Fluxo de Scanner
```
1. ScannerTab → Camera Permission
2. Camera → QR/Barcode Data
3. ScannerService → Parse Data
4. ScannerService → DatabaseService.getProduct()
5. DatabaseService → Product Info
6. ScannerService → PointsService.addPoints()
7. PointsService → NotificationService.notify()
8. ScannerTab → ResultScreen (Navigation)
```

### Fluxo de Pontos
```
1. User Action → PointsService.addPoints()
2. PointsService → Validation Logic
3. PointsService → DatabaseService.updateUserPoints()
4. DatabaseService → SQLite Update
5. PointsService → Level Calculation
6. PointsService → NotificationService.notifyLevelUp()
7. NotificationService → Local Notification
```

## 🚀 Performance e Otimização

### Otimizações Implementadas

#### 1. Lazy Loading
```dart
// Carregamento sob demanda de dados
Future<void> _loadData() async {
  if (_isLoading) return;
  setState(() => _isLoading = true);
  
  try {
    final data = await DatabaseService.getData();
    setState(() => _data = data);
  } finally {
    setState(() => _isLoading = false);
  }
}
```

#### 2. Caching
```dart
class DatabaseService {
  static final Map<String, dynamic> _cache = {};
  
  static Future<List<Map<String, dynamic>>> getCachedData(String key) async {
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    
    final data = await _fetchData(key);
    _cache[key] = data;
    return data;
  }
}
```

#### 3. Debouncing
```dart
class SearchWidget extends StatefulWidget {
  Timer? _debounce;
  
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }
}
```

### Métricas de Performance
- **Tempo de inicialização**: < 3 segundos
- **Tempo de scan**: < 2 segundos
- **Uso de memória**: < 100MB
- **Tamanho do APK**: < 50MB

## 🧪 Arquitetura de Testes

### Estrutura de Testes
```
test/
├── unit/                   # Testes unitários
│   ├── services/          # Testes de serviços
│   └── models/            # Testes de modelos
├── widget/                # Testes de widgets
│   ├── auth/              # Telas de auth
│   └── home/              # Telas principais
└── integration/           # Testes de integração
    └── app_test.dart      # Fluxos completos
```

### Estratégias de Teste

#### 1. Testes Unitários
```dart
group('AuthService Tests', () {
  test('should validate CPF correctly', () {
    expect(AuthService.isValidCPF('11144477735'), true);
    expect(AuthService.isValidCPF('12345678901'), false);
  });
  
  test('should hash password correctly', () {
    final hash = AuthService.hashPassword('password123');
    expect(hash.length, 64); // SHA-256 length
  });
});
```

#### 2. Testes de Widget
```dart
group('LoginScreen Tests', () {
  testWidgets('should show error for invalid email', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    
    await tester.enterText(find.byType(TextField).first, 'invalid-email');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    
    expect(find.text('Email inválido'), findsOneWidget);
  });
});
```

#### 3. Testes de Integração
```dart
group('App Integration Tests', () {
  testWidgets('complete user flow', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // Test registration
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();
    
    // Fill form and submit
    await tester.enterText(find.byKey(Key('name')), 'João Silva');
    await tester.enterText(find.byKey(Key('email')), 'joao@email.com');
    // ...
    
    await tester.tap(find.text('Criar Conta'));
    await tester.pumpAndSettle();
    
    // Verify navigation to main screen
    expect(find.byType(MainScreen), findsOneWidget);
  });
});
```

## 🔧 Configuração e Deploy

### Configurações por Ambiente

#### Development
```dart
class Config {
  static const String environment = 'development';
  static const bool enableLogging = true;
  static const String databaseName = 'veropreco_dev.db';
}
```

#### Production
```dart
class Config {
  static const String environment = 'production';
  static const bool enableLogging = false;
  static const String databaseName = 'veropreco.db';
}
```

### Build Configuration

#### Android
```gradle
android {
    buildTypes {
        debug {
            applicationIdSuffix ".debug"
            debuggable true
            minifyEnabled false
        }
        
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
        }
    }
}
```

#### iOS
```xml
<!-- Debug Configuration -->
<key>CFBundleIdentifier</key>
<string>com.veropreco.app.debug</string>

<!-- Release Configuration -->
<key>CFBundleIdentifier</key>
<string>com.veropreco.app</string>
```

## 📊 Monitoramento e Analytics

### Logging
```dart
class Logger {
  static void info(String message) {
    if (Config.enableLogging) {
      print('[INFO] ${DateTime.now()}: $message');
    }
  }
  
  static void error(String message, [dynamic error]) {
    if (Config.enableLogging) {
      print('[ERROR] ${DateTime.now()}: $message');
      if (error != null) print('Error details: $error');
    }
  }
}
```

### Error Handling
```dart
class ErrorHandler {
  static void handleError(dynamic error, StackTrace stackTrace) {
    Logger.error('Unhandled error', error);
    
    // Send to crash reporting service
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // Show user-friendly message
    _showErrorDialog();
  }
}
```

## 🔮 Escalabilidade e Futuro

### Preparação para Escala

#### 1. Microserviços
```dart
// Preparado para migração para APIs REST
class ApiService {
  static const String baseUrl = 'https://api.veropreco.com.br';
  
  static Future<List<Product>> getProducts() async {
    // Implementação futura de API
  }
}
```

#### 2. Cache Distribuído
```dart
// Preparado para Redis/Memcached
class CacheService {
  static Future<void> set(String key, dynamic value) async {
    // Implementação futura
  }
  
  static Future<dynamic> get(String key) async {
    // Implementação futura
  }
}
```

#### 3. Real-time Updates
```dart
// Preparado para WebSockets/Server-Sent Events
class RealtimeService {
  static Stream<PriceUpdate> priceUpdates() {
    // Implementação futura
  }
}
```

### Roadmap Técnico

#### Versão 2.0
- [ ] Migração para arquitetura BLoC
- [ ] Implementação de APIs REST
- [ ] Cache distribuído
- [ ] Sincronização offline/online

#### Versão 3.0
- [ ] Microserviços
- [ ] GraphQL
- [ ] Machine Learning para recomendações
- [ ] Real-time price updates

---

Esta arquitetura foi projetada para ser escalável, manutenível e testável, seguindo as melhores práticas do desenvolvimento Flutter e mobile. 🏗️

