# Guia de Publicação no GitHub - Ver-o-Preço

Este guia mostra como publicar o projeto Ver-o-Preço no seu GitHub pessoal.

## 🚀 Passos para Publicação

### 1. Preparar o Repositório Local

```bash
# Navegar para o diretório do projeto
cd /caminho/para/ver-o-preco-app

# Inicializar repositório Git (se ainda não foi feito)
git init

# Adicionar todos os arquivos
git add .

# Fazer o primeiro commit
git commit -m "🎉 Initial commit: Ver-o-Preço app completo

- Aplicativo Flutter completo com identidade paraense
- Sistema de scanner QR Code e código de barras
- Comparação de preços entre supermercados
- Sistema de pontos e gamificação
- Documentação técnica completa
- Arquitetura escalável e código limpo"
```

### 2. Criar Repositório no GitHub

1. **Acesse**: [github.com/raphaeldaluz](https://github.com/raphaeldaluz)
2. **Clique em**: "New repository" (botão verde)
3. **Nome do repositório**: `ver-o-preco-app`
4. **Descrição**: `🛒 Aplicativo Flutter para comparação de preços com identidade paraense - Scanner QR Code/Barcode + Gamificação`
5. **Visibilidade**: Public (para portfólio) ou Private
6. **NÃO marque**: "Add a README file" (já temos um)
7. **Clique em**: "Create repository"

### 3. Conectar e Enviar o Código

```bash
# Adicionar o repositório remoto
git remote add origin https://github.com/raphaeldaluz/ver-o-preco-app.git

# Definir branch principal
git branch -M main

# Enviar código para o GitHub
git push -u origin main
```

### 4. Configurar o Repositório

#### Tags e Releases
```bash
# Criar tag da versão 1.0.0
git tag -a v1.0.0 -m "🎉 Ver-o-Preço v1.0.0 - Lançamento inicial

✨ Funcionalidades principais:
- Scanner QR Code e código de barras
- Comparação de preços entre supermercados
- Sistema de pontos e gamificação
- Interface com identidade paraense
- Documentação técnica completa"

# Enviar tags
git push origin --tags
```

#### Criar Release no GitHub
1. Vá para: `https://github.com/raphaeldaluz/ver-o-preco-app/releases`
2. Clique em "Create a new release"
3. **Tag version**: `v1.0.0`
4. **Release title**: `🛒 Ver-o-Preço v1.0.0 - Lançamento Inicial`
5. **Description**: Cole o conteúdo do CHANGELOG.md
6. **Attach binaries**: (opcional) APK compilado
7. Clique em "Publish release"

### 5. Configurar README Badges

Adicione badges profissionais no topo do README.md:

```markdown
# Ver-o-Preço 🛒

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0.0-blue.svg)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/raphaeldaluz/ver-o-preco-app.svg)](https://github.com/raphaeldaluz/ver-o-preco-app/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/raphaeldaluz/ver-o-preco-app.svg)](https://github.com/raphaeldaluz/ver-o-preco-app/network)
[![GitHub issues](https://img.shields.io/github/issues/raphaeldaluz/ver-o-preco-app.svg)](https://github.com/raphaeldaluz/ver-o-preco-app/issues)
```

### 6. Configurar GitHub Pages (Opcional)

Para documentação online:

1. Vá para: Settings → Pages
2. **Source**: Deploy from a branch
3. **Branch**: main
4. **Folder**: / (root)
5. Clique em "Save"

A documentação estará disponível em:
`https://raphaeldaluz.github.io/ver-o-preco-app/`

### 7. Configurar Issues Templates

Crie `.github/ISSUE_TEMPLATE/bug_report.md`:

```markdown
---
name: Bug report
about: Criar um relatório de bug
title: '[BUG] '
labels: bug
assignees: raphaeldaluz
---

**Descreva o bug**
Uma descrição clara do que é o bug.

**Para Reproduzir**
Passos para reproduzir o comportamento:
1. Vá para '...'
2. Clique em '....'
3. Role para baixo até '....'
4. Veja o erro

**Comportamento Esperado**
Uma descrição clara do que você esperava que acontecesse.

**Screenshots**
Se aplicável, adicione screenshots para ajudar a explicar o problema.

**Informações do Dispositivo:**
 - Dispositivo: [ex. iPhone6, Samsung Galaxy S21]
 - OS: [ex. iOS8.1, Android 12]
 - Versão do App: [ex. 1.0.0]

**Contexto Adicional**
Adicione qualquer outro contexto sobre o problema aqui.
```

### 8. Configurar Actions (CI/CD)

Crie `.github/workflows/flutter.yml`:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.5'
        
    - name: Install dependencies
      run: |
        cd ver_o_preco_flutter
        flutter pub get
        
    - name: Analyze code
      run: |
        cd ver_o_preco_flutter
        flutter analyze
        
    - name: Run tests
      run: |
        cd ver_o_preco_flutter
        flutter test
```

### 9. Adicionar Tópicos no GitHub

No repositório, clique na engrenagem ao lado de "About" e adicione:

**Topics:**
- `flutter`
- `dart`
- `mobile-app`
- `qr-code`
- `barcode-scanner`
- `price-comparison`
- `gamification`
- `para`
- `brazil`
- `regional-app`

### 10. Configurar Proteção da Branch

1. Vá para: Settings → Branches
2. Clique em "Add rule"
3. **Branch name pattern**: `main`
4. Marque:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging

## 📊 Estrutura Final do Repositório

```
ver-o-preco-app/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   └── bug_report.md
│   └── workflows/
│       └── flutter.yml
├── ver_o_preco_flutter/          # Código Flutter
│   ├── lib/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── design/                       # Assets de design
├── references/                   # Imagens de referência
├── README.md                     # Documentação principal
├── INSTALLATION.md               # Guia de instalação
├── ARCHITECTURE.md               # Arquitetura técnica
├── CHANGELOG.md                  # Histórico de versões
├── EXECUTIVE_SUMMARY.md          # Resumo executivo
├── PUBLISH_GUIDE.md             # Este guia
├── LICENSE                       # Licença MIT
└── .gitignore                   # Arquivos ignorados
```

## 🎯 Dicas Importantes

### Para Portfólio
- ✅ Use README atrativo com screenshots
- ✅ Adicione badges profissionais
- ✅ Documente bem o projeto
- ✅ Use releases para versões
- ✅ Mantenha código limpo e comentado

### Para Colaboração
- ✅ Configure templates de issues
- ✅ Use GitHub Actions para CI/CD
- ✅ Proteja a branch main
- ✅ Use pull requests
- ✅ Documente processo de contribuição

### Para Visibilidade
- ✅ Use tópicos relevantes
- ✅ Escreva boa descrição
- ✅ Adicione screenshots/GIFs
- ✅ Compartilhe nas redes sociais
- ✅ Submeta para showcases Flutter

## 🚀 Próximos Passos

1. **Compile o APK**: `flutter build apk --release`
2. **Teste em dispositivos reais**
3. **Colete feedback** de usuários
4. **Implemente melhorias**
5. **Considere publicação** nas lojas de app

---

**Parabéns!** 🎉 Seu projeto Ver-o-Preço agora está profissionalmente hospedado no GitHub e pronto para impressionar recrutadores e colaboradores!

**Link do seu repositório**: https://github.com/raphaeldaluz/ver-o-preco-app

