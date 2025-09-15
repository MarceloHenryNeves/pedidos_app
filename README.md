# Restaurant App - Sistema de Pedidos para Tablets

Um aplicativo Flutter para gerenciamento de pedidos em restaurantes/cafeterias, onde cada mesa possui um tablet para realizar pedidos de forma independente.

## 📱 Funcionalidades

### ✅ Implementadas
- **Seleção de Mesas**: Interface para escolher e gerenciar mesas
- **Cardápio Digital**: Visualização de produtos organizados por categorias
- **Carrinho de Compras**: Adicionar, editar e remover itens do pedido
- **Acúmulo de Pedidos**: Valores se acumulam por mesa até o pagamento
- **Sincronização em Tempo Real**: Dados sincronizados via Firebase Firestore
- **Interface Otimizada para Tablets**: Layout responsivo e intuitivo

### 🚧 Próximas Funcionalidades
- Upload de imagens para produtos
- Relatórios de vendas
- Sistema de impressão
- Modo administrativo
- Integração com formas de pagamento

## 🏗️ Arquitetura

O projeto segue as melhores práticas de desenvolvimento Flutter:

```
lib/
├── main.dart              # Entrada da aplicação
├── models/                # Modelos de dados
├── services/              # Serviços Firebase
├── providers/             # Gerenciamento de estado (Provider)
├── screens/               # Telas da aplicação
├── widgets/               # Widgets reutilizáveis
├── utils/                 # Utilitários
└── constants/             # Constantes da aplicação
```

### Tecnologias Utilizadas

- **Flutter 3.5+**: Framework de desenvolvimento
- **Firebase Firestore**: Banco de dados em tempo real
- **Provider**: Gerenciamento de estado
- **Material Design 3**: Interface moderna e consistente

## 🚀 Instalação e Configuração

### Pré-requisitos

- Flutter SDK 3.5.4 ou superior
- Dart SDK incluído no Flutter
- Android Studio / VS Code
- Conta no Firebase

### 1. Clone o Repositório

```bash
git clone <url-do-repositorio>
cd restaurant_app
```

### 2. Instalar Dependências

```bash
flutter pub get
```

### 3. Configurar Firebase

Siga o guia detalhado em [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### 4. Executar o Aplicativo

```bash
flutter run
```

## 📊 Modelos de Dados

### TableModel
- Gerencia informações das mesas
- Controla status (livre/ocupada) e valores acumulados

### ProductModel & CategoryModel  
- Estrutura do cardápio com categorias e produtos
- Preços, descrições e imagens

### OrderModel & OrderItemModel
- Sistema completo de pedidos
- Estados: carrinho → confirmado → pago

## 🎯 Fluxo de Uso

1. **Seleção de Mesa**: Usuário escolhe uma mesa disponível
2. **Navegação do Cardápio**: Explora produtos por categoria
3. **Adicionar ao Carrinho**: Seleciona produtos com quantidades e observações
4. **Revisar Pedido**: Confirma itens e valor total no carrinho
5. **Confirmar Pedido**: Pedido é enviado e valor acumulado na mesa
6. **Acúmulo**: Novos pedidos somam ao total da mesa
7. **Pagamento**: Mesa é liberada após processamento do pagamento

## 🔧 Desenvolvimento

### Comandos Úteis

```bash
# Análise de código
flutter analyze

# Formatação de código
flutter format .

# Testes
flutter test

# Build para produção
flutter build apk --release
```

### Estrutura de Providers

- **TableProvider**: Gerencia mesas e seleção
- **ProductProvider**: Controla categorias e produtos  
- **CartProvider**: Carrinho de compras da sessão
- **OrderProvider**: Histórico e criação de pedidos

## 📱 Screenshots

*Em breve - screenshots das principais telas*

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Crie um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Equipe

Desenvolvido seguindo o guia detalhado do `restaurant_app_guide.md` com foco em boas práticas e arquitetura escalável.

---

**Versão**: 1.0.0  
**Status**: Em desenvolvimento  
**Plataforma**: Android (iOS em breve)
