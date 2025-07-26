# Guia de Instalação - Ver-o-Preço

Este guia fornece instruções detalhadas para configurar e executar o aplicativo Ver-o-Preço em seu ambiente de desenvolvimento.

## 📋 Pré-requisitos

### Sistema Operacional
- **Windows**: Windows 10 ou superior
- **macOS**: macOS 10.14 ou superior
- **Linux**: Ubuntu 18.04 ou superior (ou distribuições equivalentes)

### Ferramentas Necessárias

#### 1. Flutter SDK
```bash
# Baixe o Flutter SDK
# Windows/Linux:
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz

# macOS:
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.24.5-stable.zip
unzip flutter_macos_3.24.5-stable.zip

# Adicione ao PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

#### 2. Android Studio
- Baixe e instale o [Android Studio](https://developer.android.com/studio)
- Configure o Android SDK (API 21 ou superior)
- Instale o plugin Flutter
- Configure um emulador Android ou conecte um dispositivo físico

#### 3. VS Code (Opcional)
- Baixe e instale o [VS Code](https://code.visualstudio.com/)
- Instale as extensões:
  - Flutter
  - Dart
  - Android iOS Emulator

#### 4. Git
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# macOS (com Homebrew)
brew install git

# Windows
# Baixe do site oficial: https://git-scm.com/
```

## 🚀 Instalação Passo a Passo

### Passo 1: Verificar Instalação do Flutter
```bash
flutter doctor
```

Certifique-se de que todos os itens estejam marcados com ✓. Se houver problemas, siga as instruções fornecidas.

### Passo 2: Clonar o Repositório
```bash
git clone https://github.com/raphaeldaluz/ver-o-preco-app.git
cd ver-o-preco-app/ver_o_preco_flutter
```

### Passo 3: Instalar Dependências
```bash
flutter pub get
```

### Passo 4: Configurar Permissões

#### Android (android/app/src/main/AndroidManifest.xml)
As permissões já estão configuradas no projeto:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.VIBRATE" />
```

#### iOS (ios/Runner/Info.plist)
Adicione as seguintes permissões:
```xml
<key>NSCameraUsageDescription</key>
<string>Este app precisa acessar a câmera para escanear códigos QR e códigos de barras</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Este app precisa acessar a galeria para salvar imagens de produtos</string>
```

### Passo 5: Configurar Dispositivo/Emulador

#### Para Android
```bash
# Listar dispositivos disponíveis
flutter devices

# Criar emulador (se necessário)
flutter emulators --create --name pixel_7

# Iniciar emulador
flutter emulators --launch pixel_7
```

#### Para iOS (apenas macOS)
```bash
# Abrir simulador
open -a Simulator

# Listar simuladores disponíveis
xcrun simctl list devices
```

### Passo 6: Executar o Aplicativo
```bash
# Modo debug
flutter run

# Modo release
flutter run --release

# Para dispositivo específico
flutter run -d <device_id>
```

## 🔧 Configuração Avançada

### Configuração do Banco de Dados
O aplicativo usa SQLite local. O banco é criado automaticamente na primeira execução com dados de exemplo.

#### Localização do Banco
- **Android**: `/data/data/com.example.ver_o_preco/databases/`
- **iOS**: `~/Library/Developer/CoreSimulator/Devices/[UUID]/data/Containers/Data/Application/[UUID]/Documents/`

### Configuração de Notificações

#### Android
As configurações já estão no `android/app/src/main/AndroidManifest.xml`:
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.PACKAGE_REPLACED"/>
        <data android:scheme="package" />
    </intent-filter>
</receiver>
```

#### iOS
Configure no `ios/Runner/AppDelegate.swift`:
```swift
import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🧪 Testes e Validação

### Executar Testes
```bash
# Análise estática
flutter analyze

# Testes unitários
flutter test

# Testes de widget
flutter test test/widget_test.dart

# Cobertura de testes
flutter test --coverage
```

### Validar Funcionalidades

#### 1. Teste de Autenticação
- Cadastre um novo usuário
- Faça login com as credenciais
- Verifique se os dados persistem após reiniciar o app

#### 2. Teste de Scanner
- Use um QR Code de teste
- Escaneie um código de barras válido
- Verifique se os dados são exibidos corretamente

#### 3. Teste de Pontos
- Execute ações que geram pontos
- Verifique se a pontuação é atualizada
- Teste o resgate de recompensas

## 🐛 Solução de Problemas

### Problemas Comuns

#### 1. Erro de Dependências
```bash
# Limpar cache
flutter clean
flutter pub get

# Atualizar dependências
flutter pub upgrade
```

#### 2. Problemas de Permissão (Android)
```bash
# Reinstalar app
flutter clean
flutter run --uninstall-first
```

#### 3. Erro de Compilação iOS
```bash
# Limpar build iOS
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

#### 4. Problemas de Scanner
- Verifique se a câmera está funcionando
- Teste em dispositivo físico (emulador pode ter limitações)
- Verifique permissões de câmera

### Logs de Debug
```bash
# Logs detalhados
flutter run --verbose

# Logs específicos
flutter logs

# Logs do dispositivo Android
adb logcat
```

## 📱 Build para Produção

### Android APK
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recomendado para Play Store)
flutter build appbundle --release
```

### iOS IPA
```bash
# Build para iOS
flutter build ios --release

# Abrir no Xcode para assinatura
open ios/Runner.xcworkspace
```

### Configurações de Release

#### Android (android/app/build.gradle)
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.veropreco.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

## 🔐 Configuração de Segurança

### Assinatura Android
1. Gere uma keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configure em `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<location of the key store file>
```

### Configuração iOS
1. Configure Team ID no Xcode
2. Configure Bundle Identifier único
3. Configure provisioning profiles

## 📊 Monitoramento

### Analytics (Opcional)
Para adicionar analytics, configure:
```yaml
dependencies:
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
```

### Performance Monitoring
```bash
# Profile de performance
flutter run --profile

# Análise de tamanho do app
flutter build apk --analyze-size
```

## 🆘 Suporte

### Recursos de Ajuda
- [Documentação Flutter](https://docs.flutter.dev/)
- [Cookbook Flutter](https://docs.flutter.dev/cookbook)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Community](https://flutter.dev/community)

### Contato
- **Email**: raphaeldaluz@gmail.com
- **GitHub Issues**: [Reportar Problema](https://github.com/raphaeldaluz/ver-o-preco-app/issues)

---

Após seguir este guia, você deve ter o Ver-o-Preço funcionando perfeitamente em seu ambiente de desenvolvimento! 🚀

