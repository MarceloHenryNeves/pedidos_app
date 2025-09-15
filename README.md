# 📱 Restaurant Order App

Um aplicativo completo de pedidos para restaurantes, cafeterias e lanchonetes desenvolvido em **Flutter** com **Firebase**, onde cada mesa possui um tablet para realizar pedidos de forma independente.

## 🚀 Funcionalidades Principais

- **🪑 Gestão de Mesas**: Sistema de seleção e controle de mesas com status em tempo real
- **📱 Interface para Tablets**: Interface otimizada especificamente para tablets
- **🛒 Carrinho por Mesa**: Cada mesa mantém seu próprio carrinho de compras
- **💰 Acúmulo de Valores**: Os pedidos se acumulam até o momento do pagamento
- **🔄 Sincronização em Tempo Real**: Todos os dados sincronizados via Firebase Firestore
- **🍕 Gestão de Produtos**: Sistema completo de categorias e produtos
- **💳 Sistema de Pagamento**: Reset automático da mesa após pagamento confirmado

## 🛠️ Tecnologias Utilizadas

- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **Gerenciamento de Estado**: Provider
- **Banco de Dados**: Cloud Firestore (NoSQL)

## 🏗️ Arquitetura do Projeto

```
lib/
├── main.dart
├── models/           # Modelos de dados (Table, Product, Order, etc.)
├── services/         # Serviços Firebase (CRUD operations)
├── providers/        # Gerenciamento de estado
├── screens/          # Telas da aplicação
├── widgets/          # Widgets reutilizáveis
├── utils/            # Utilitários e helpers
└── constants/        # Constantes da aplicação
```

## 📊 Estrutura de Dados

### Coleções Firebase:
- **tables**: Controle de mesas (número, status, valor acumulado)
- **categories**: Categorias de produtos
- **products**: Itens do cardápio
- **orders**: Pedidos realizados
- **order_items**: Itens individuais dos pedidos

## 🎯 Fluxo de Funcionamento

1. **Seleção da Mesa**: Cliente seleciona mesa disponível no tablet
2. **Navegação no Menu**: Explora categorias e produtos do cardápio
3. **Adição ao Carrinho**: Adiciona itens desejados com quantidades
4. **Confirmação do Pedido**: Confirma pedido que é adicionado ao total da mesa
5. **Acúmulo**: Mesa acumula todos os pedidos até o pagamento
6. **Pagamento**: Valor total é pago e mesa é liberada automaticamente

## 🔧 Configuração e Instalação

### Pré-requisitos
- Flutter SDK
- Conta Firebase
- Dispositivos tablet Android/iOS

### Passos para Configuração

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/restaurant-order-app.git
cd restaurant-order-app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure o Firebase**
- Crie um projeto no Firebase Console
- Adicione os arquivos de configuração (`google-services.json` para Android e `GoogleService-Info.plist` para iOS)
- Configure as regras do Firestore

4. **Execute o aplicativo**
```bash
flutter run
```

## 📦 Principais Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.x.x
  cloud_firestore: ^4.x.x
  firebase_auth: ^4.x.x
  provider: ^6.x.x
  uuid: ^3.x.x
  intl: ^0.18.x
  shared_preferences: ^2.x.x
```

## 🚀 Funcionalidades Futuras

- 🖨️ Integração com impressora térmica
- 📊 Dashboard administrativo
- 🔔 Notificações push para cozinha
- 📈 Relatórios de vendas
- 🏢 Suporte multi-estabelecimento
- 🎨 Temas customizáveis

## 🤝 Contribuição

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

⭐ **Não esqueça de dar uma estrela se este projeto foi útil para você!**
