# Guia de Layout da Aplicação

## Filosofia de Design

O layout da aplicação deve seguir os princípios de **design minimalista e clean**, priorizando a funcionalidade e a experiência do usuário através da simplicidade e clareza visual.

## Paleta de Cores

### Cores Principais
- **Azul Principal**: `#3B82F6` (Azul moderno e profissional)
- **Azul Secundário**: `#60A5FA` (Para elementos interativos)
- **Azul Suave**: `#DBEAFE` (Para fundos e destaques sutis)

### Cores Neutras
- **Branco Principal**: `#FFFFFF` (Fundo principal)
- **Branco Suave**: `#FAFAFA` (Fundos secundários)
- **Cinza Claro**: `#F3F4F6` (Divisores e bordas)
- **Cinza Médio**: `#9CA3AF` (Texto secundário)
- **Cinza Escuro**: `#374151` (Texto principal)

### Cores de Apoio
- **Verde Sucesso**: `#10B981` (Confirmações e sucessos)
- **Laranja Alerta**: `#F59E0B` (Avisos)
- **Vermelho Erro**: `#EF4444` (Erros e alertas críticos)

## Princípios de Layout

### 1. Espaçamento Consistente
- **Espaçamento base**: 8px, 16px, 24px, 32px, 48px
- **Margens laterais**: Mínimo 16px em mobile, 24px em tablet
- **Espaçamento entre elementos**: Múltiplos de 8px

### 2. Tipografia Limpa
- **Fonte principal**: San Francisco (iOS) / Roboto (Android) / Inter (Web)
- **Hierarquia clara**:
  - Título principal: 28px, peso 600
  - Subtítulos: 20px, peso 500
  - Texto corpo: 16px, peso 400
  - Texto secundário: 14px, peso 400

### 3. Elementos Visuais

#### Cartões e Containers
- **Raio de borda**: 12px para cartões, 8px para botões
- **Sombra sutil**: `box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06)`
- **Fundo**: Branco com borda cinza claro (`#F3F4F6`)

#### Botões
- **Primário**: Fundo azul principal, texto branco
- **Secundário**: Fundo transparente, borda azul, texto azul
- **Altura mínima**: 44px (área tocável confortável)

#### Campos de Input
- **Fundo**: Branco ou cinza muito claro (`#FAFAFA`)
- **Borda**: Cinza claro, que muda para azul no foco
- **Placeholder**: Cinza médio

## Estrutura de Tela

### Header/Cabeçalho
- Fundo branco com sombra sutil
- Logo/título à esquerda
- Ações importantes à direita
- Altura: 56px em mobile, 64px em desktop

### Área de Conteúdo
- Fundo branco ou cinza muito claro
- Padding lateral consistente
- Rolagem suave quando necessário

### Navegação (se aplicável)
- **Tab Bar**: Fundo branco, ícones em cinza que ficam azuis quando ativos
- **Navigation Drawer**: Fundo branco com itens espaçados

### Estados de Loading e Vazio
- **Loading**: Skeleton screens com animação suave
- **Estados vazios**: Ilustrações minimalistas em tons de cinza

## Diretrizes de Implementação

### O que FAZER:
✅ Usar muito espaço em branco
✅ Agrupar elementos relacionados
✅ Manter consistência visual
✅ Priorizar legibilidade
✅ Usar ícones simples e reconhecíveis
✅ Implementar transições suaves (300ms)

### O que EVITAR:
❌ Sobrecarregar com muitos elementos
❌ Usar muitas cores diferentes
❌ Textos muito pequenos (menor que 14px)
❌ Elementos muito próximos
❌ Gradientes ou efeitos excessivos
❌ Bordas muito grossas ou contrastantes

## Responsividade

### Mobile (< 768px)
- Layout em coluna única
- Elementos empilhados verticalmente
- Botões ocupando largura total quando apropriado

### Tablet (768px - 1024px)
- Layout adaptativo com 2 colunas quando possível
- Maior uso do espaço horizontal

### Desktop (> 1024px)
- Layout centrado com largura máxima
- Sidebar fixa se aplicável
- Maior densidade de informação

## Acessibilidade

- **Contraste mínimo**: 4.5:1 para texto normal
- **Área tocável mínima**: 44x44px
- **Foco visível**: Contorno azul nos elementos interativos
- **Textos alternativos**: Para todos os ícones e imagens

## Exemplos de Aplicação

### Dashboard/Home
- Header com saudação e ações rápidas
- Cards informativos com ícones simples
- Lista de itens com separadores sutis
- FAB (se necessário) em azul principal

### Formulários
- Labels claras acima dos campos
- Campos com fundo cinza claro
- Botão de envio destacado em azul
- Mensagens de erro em vermelho suave

---

*Este documento serve como referência para manter a consistência visual em toda a aplicação. Revise regularmente para garantir que todas as telas sigam estas diretrizes.*