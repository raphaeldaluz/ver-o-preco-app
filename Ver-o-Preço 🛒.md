# Ver-o-Preço 🛒

Um aplicativo Flutter inovador para comparação de preços de supermercados, inspirado na cultura paraense do mercado Ver-o-Peso. O app permite aos usuários escanear QR Codes de notas fiscais e códigos de barras de produtos para encontrar os melhores preços na região.

## 🎯 Visão Geral

O Ver-o-Preço é um aplicativo mobile desenvolvido em Flutter que revoluciona a forma como os consumidores fazem compras, oferecendo:

- **Comparação inteligente de preços** entre supermercados
- **Scanner de QR Code** para notas fiscais
- **Scanner de código de barras** para produtos individuais
- **Sistema de pontos e gamificação** para engajar usuários
- **Notificações inteligentes** sobre mudanças de preços
- **Interface intuitiva** inspirada no design do Kinvo e iFood
- **Identidade visual paraense** com cores regionais

## 🚀 Funcionalidades Principais

### 📱 Autenticação e Perfil
- Cadastro completo com validação de CPF único
- Login seguro com criptografia SHA-256
- Perfil personalizável com dados do usuário
- Sistema de sessão persistente

### 🔍 Scanner Inteligente
- **QR Code Scanner**: Lê notas fiscais e extrai dados dos produtos
- **Barcode Scanner**: Identifica produtos e compara preços
- Feedback visual e sonoro para confirmação de scan
- Histórico de produtos escaneados

### 💰 Comparação de Preços
- Base de dados com 3 supermercados paraenses
- Algoritmo inteligente de comparação
- Indicação do melhor preço e % de economia
- Preços promocionais com data de validade
- Atualização automática de preços

### ⭐ Sistema de Favoritos
- Marcar produtos como favoritos
- Notificações quando preço baixa
- Acompanhamento de variações de preço
- Lista personalizada de produtos preferidos

### 🎮 Gamificação e Pontos
- **10 tipos de ações** que geram pontos
- **6 níveis de usuário** (Iniciante → Lenda)
- **5 tipos de recompensas** trocáveis
- Sistema de ranking entre usuários
- Sequências (streaks) de uso diário

### 📋 Listas de Compras
- Criação de múltiplas listas
- Adição automática de produtos escaneados
- Progresso visual de compras
- Compartilhamento de listas

### 🔔 Notificações Inteligentes
- Alertas de mudança de preços
- Notificações de pontos ganhos
- Lembretes de promoções
- Feedback de ações realizadas

## 🎨 Design e UX

### Identidade Visual Paraense
- **Azul Ver-o-Peso**: Cor principal inspirada no mercado histórico
- **Verde Amazônia**: Representando a natureza local
- **Laranja Açaí**: Destacando produtos regionais
- **Gradientes naturais**: Evocando o ambiente amazônico

### Interface Intuitiva
- Design similar ao Kinvo e iFood para familiaridade
- Navegação por bottom tabs
- Componentes responsivos e acessíveis
- Micro-interações e animações suaves
- Feedback visual constante

## 🏗️ Arquitetura Técnica

### Tecnologias Utilizadas
- **Flutter 3.24.5**: Framework principal
- **Dart**: Linguagem de programação
- **SQLite**: Banco de dados local
- **SharedPreferences**: Armazenamento de sessão
- **QR Code Scanner**: Leitura de códigos
- **Local Notifications**: Sistema de notificações

### Estrutura do Projeto
```
lib/
├── constants/          # Cores, estilos e dimensões
├── models/            # Modelos de dados
├── services/          # Lógica de negócio
├── views/             # Interfaces do usuário
│   ├── auth/          # Telas de autenticação
│   ├── home/          # Telas principais
│   ├── points/        # Sistema de pontos
│   └── scanner/       # Funcionalidades de scan
└── main.dart          # Ponto de entrada
```

### Padrões Implementados
- **Service Layer**: Separação da lógica de negócio
- **Model-View**: Organização clara de dados e interface
- **Singleton**: Gerenciamento de estado global
- **Observer**: Sistema de notificações
- **Strategy**: Diferentes tipos de scanner

## 📊 Base de Dados

### Supermercados Cadastrados
1. **Supermercado Pará** - Rede local tradicional
2. **Mercado Amazônia** - Foco em produtos regionais
3. **Hiper Belém** - Grande variedade de produtos

### Produtos de Exemplo
- Arroz Tio João 5kg
- Feijão Carioca 1kg
- Açúcar Cristal União 1kg
- Óleo de Soja Soya 900ml
- Leite Integral Nestlé 1L

### Estrutura do Banco
- **users**: Dados dos usuários
- **produtos**: Catálogo de produtos
- **supermercados**: Informações das lojas
- **precos**: Preços e promoções
- **favoritos**: Produtos favoritos dos usuários
- **pontos_historico**: Histórico de pontuação

## 🎯 Sistema de Pontos

### Ações que Geram Pontos
| Ação | Pontos | Descrição |
|------|--------|-----------|
| Scan QR Code | 10 | Escanear nota fiscal |
| Scan Código de Barras | 5 | Escanear produto |
| Primeiro Login | 50 | Bônus de boas-vindas |
| Perfil Completo | 25 | Completar cadastro |
| Favoritar Produto | 2 | Adicionar aos favoritos |
| Criar Lista | 15 | Nova lista de compras |
| Compartilhar App | 30 | Indicar para amigos |
| Login Diário | 5 | Acesso diário |
| Sequência Semanal | 50 | 7 dias consecutivos |
| Sequência Mensal | 200 | 30 dias consecutivos |

### Níveis de Usuário
1. **Iniciante** (0 pts) - Verde
2. **Explorador** (100 pts) - Azul
3. **Caçador de Ofertas** (300 pts) - Roxo
4. **Expert em Economia** (600 pts) - Laranja
5. **Mestre das Compras** (1000 pts) - Vermelho
6. **Lenda do Ver-o-Preço** (1500 pts) - Dourado

### Recompensas Disponíveis
- **Desconto 5%** (100 pts) - Parceiros selecionados
- **Desconto 10%** (200 pts) - Maior economia
- **Frete Grátis** (150 pts) - Delivery sem custo
- **Cashback 2%** (300 pts) - Dinheiro de volta
- **Produto Grátis** (500 pts) - Item até R$ 10

## 🔧 Instalação e Configuração

### Pré-requisitos
- Flutter SDK 3.24.5 ou superior
- Dart SDK 3.0.0 ou superior
- Android Studio / VS Code
- Dispositivo Android/iOS ou emulador

### Passos de Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/raphaeldaluz/ver-o-preco-app.git
cd ver-o-preco-app/ver_o_preco_flutter
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure as permissões**
   - Android: Câmera e armazenamento já configurados
   - iOS: Adicione permissões no Info.plist

4. **Execute o aplicativo**
```bash
flutter run
```

### Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  qr_code_scanner: ^1.0.1
  barcode_scan2: ^4.3.3
  sqflite: ^2.4.1
  shared_preferences: ^2.3.2
  http: ^1.2.2
  image_picker: ^1.1.2
  flutter_local_notifications: ^17.2.4
  permission_handler: ^11.2.0
  cpf_cnpj_validator: ^2.0.0
  email_validator: ^2.1.17
  crypto: ^3.0.5
  timezone: ^0.9.4
```

## 🧪 Testes

### Cenários de Teste
1. **Autenticação**
   - Cadastro com CPF válido/inválido
   - Login com credenciais corretas/incorretas
   - Validação de campos obrigatórios

2. **Scanner**
   - QR Code de nota fiscal válida
   - Código de barras de produto existente
   - Tratamento de códigos inválidos

3. **Comparação de Preços**
   - Busca por produtos existentes
   - Cálculo correto de economia
   - Exibição de promoções ativas

4. **Sistema de Pontos**
   - Adição correta de pontos por ação
   - Progressão de níveis
   - Resgate de recompensas

### Comandos de Teste
```bash
# Análise estática
flutter analyze

# Testes unitários
flutter test

# Testes de integração
flutter drive --target=test_driver/app.dart
```

## 📱 Compatibilidade

### Plataformas Suportadas
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 12.0+

### Dispositivos Testados
- Smartphones Android (5" a 6.7")
- Tablets Android (7" a 10")
- iPhones (SE a Pro Max)
- iPads (Mini a Pro)

### Recursos Necessários
- Câmera traseira para scanner
- Conexão com internet (opcional para uso offline)
- 100MB de espaço de armazenamento
- 2GB de RAM recomendado

## 🚀 Roadmap Futuro

### Versão 2.0
- [ ] Integração com APIs de supermercados reais
- [ ] Sistema de cupons digitais
- [ ] Comparação de preços online
- [ ] Integração com delivery

### Versão 3.0
- [ ] Inteligência artificial para recomendações
- [ ] Análise de padrões de compra
- [ ] Alertas de promoções personalizados
- [ ] Programa de fidelidade expandido

### Funcionalidades Avançadas
- [ ] Reconhecimento de imagem de produtos
- [ ] Comparação nutricional
- [ ] Histórico de preços com gráficos
- [ ] Compartilhamento social de ofertas

## 🤝 Contribuição

### Como Contribuir
1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Diretrizes
- Siga os padrões de código Dart/Flutter
- Adicione testes para novas funcionalidades
- Mantenha a documentação atualizada
- Use commits semânticos

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👥 Equipe

### Desenvolvedor Principal
- **Nome**: Raphael da Luz
- **GitHub**: [github.com/raphaeldaluz](https://github.com/raphaeldaluz)
- **Email**: raphaeldaluz@gmail.com

### Agradecimentos
- Comunidade Flutter Brasil
- Mercado Ver-o-Peso (inspiração cultural)
- Usuários beta testers
- Supermercados parceiros

## 📞 Suporte

### Canais de Suporte
- **GitHub**: [github.com/raphaeldaluz/ver-o-preco-app](https://github.com/raphaeldaluz/ver-o-preco-app)
- **Email**: raphaeldaluz@gmail.com
- **Issues**: [Reportar Problema](https://github.com/raphaeldaluz/ver-o-preco-app/issues)

### Reportar Bugs
Use o sistema de Issues do GitHub para reportar bugs ou solicitar funcionalidades.

---

**Ver-o-Preço** - Economize como um verdadeiro paraense! 🌿🛒

