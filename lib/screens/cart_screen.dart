import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/table_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/table_provider.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  final TableModel table;

  const CartScreen({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho - Mesa ${table.number}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.isNotEmpty) {
                return TextButton(
                  onPressed: () => _showClearCartDialog(context),
                  child: const Text('Limpar'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          
          if (cartProvider.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Carrinho vazio',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione produtos do cardápio para fazer seu pedido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (cartProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro no carrinho',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cartProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => cartProvider.clearError(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return CartItemCard(
                      item: item,
                      onQuantityChanged: (newQuantity) {
                        cartProvider.updateItemQuantity(
                          item.productId,
                          newQuantity,
                          observations: item.observations,
                        );
                      },
                      onRemove: () {
                        cartProvider.removeItem(
                          item.productId,
                          observations: item.observations,
                        );
                      },
                      onObservationsChanged: (newObservations) {
                        cartProvider.updateItemObservations(
                          item.productId,
                          item.observations,
                          newObservations,
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total do pedido:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'R\$ ${cartProvider.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _confirmOrder(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Confirmar Pedido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Carrinho'),
        content: const Text('Tem certeza que deseja remover todos os itens do carrinho?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.of(context).pop();
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _confirmOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Pedido - Mesa ${table.number}'),
        content: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${cartProvider.itemCount} itens'),
                const SizedBox(height: 8),
                Text(
                  'Total: R\$ ${cartProvider.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Confirmar este pedido?'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          Consumer2<CartProvider, OrderProvider>(
            builder: (context, cartProvider, orderProvider, child) {
              return ElevatedButton(
                onPressed: orderProvider.loading 
                    ? null 
                    : () async {
                        await _processOrder(context, cartProvider, orderProvider);
                      },
                child: orderProvider.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirmar'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder(
    BuildContext context,
    CartProvider cartProvider,
    OrderProvider orderProvider,
  ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final tableProvider = context.read<TableProvider>();
    
    try {
      final orderId = await orderProvider.createOrder(
        tableId: table.id,
        items: cartProvider.items,
      );

      if (orderId != null) {
        final newTotal = table.currentTotal + cartProvider.total;
        await tableProvider.updateTableTotal(table.id, newTotal);
        
        cartProvider.clearCart();
        
        if (context.mounted) {
          navigator.pop();
          navigator.pop();
          
          messenger.showSnackBar(
            SnackBar(
              content: Text('Pedido confirmado para Mesa ${table.number}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context.mounted) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Erro ao confirmar pedido. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}