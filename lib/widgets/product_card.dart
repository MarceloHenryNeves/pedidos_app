import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../models/table_model.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final TableModel table;

  const ProductCard({
    super.key,
    required this.product,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: AppTheme.lightGray,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showProductDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagem do produto
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppTheme.lightBlue,
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.restaurant,
                                  size: 48,
                                  color: AppTheme.primaryBlue,
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 48,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                ),
              ),
              
              // Conteúdo do produto
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome do produto
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Descrição
                      if (product.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Preço e quantidade
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$ ${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              final quantity = cartProvider.getItemQuantity(product.id);
                              
                              if (quantity > 0) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      color: AppTheme.primaryWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }
                              
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int quantity = 1;
        final observationsController = TextEditingController();
        
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            backgroundColor: AppTheme.primaryWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Conteúdo scrollável
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem
                          if (product.imageUrl.isNotEmpty)
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppTheme.lightBlue,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.restaurant,
                                        size: 64,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                          // Descrição
                          if (product.description.isNotEmpty) ...[
                            Text(
                              product.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.mediumGray,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Preço
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.lightBlue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: AppTheme.primaryBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'R\$ ${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Seletor de quantidade
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantidade',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppTheme.darkGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.lightGray),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Botão de diminuir
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: quantity > 1 
                                            ? () => setState(() => quantity--)
                                            : null,
                                        borderRadius: const BorderRadius.horizontal(
                                          left: Radius.circular(8),
                                        ),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: quantity > 1 
                                                ? Colors.transparent
                                                : AppTheme.lightGray.withOpacity(0.5),
                                            borderRadius: const BorderRadius.horizontal(
                                              left: Radius.circular(8),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: quantity > 1 
                                                ? AppTheme.primaryBlue
                                                : AppTheme.mediumGray,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Display da quantidade
                                    Container(
                                      width: 80,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        border: Border.symmetric(
                                          vertical: BorderSide(color: AppTheme.lightGray),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$quantity',
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            color: AppTheme.darkGray,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Botão de aumentar
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: quantity < 99 
                                            ? () => setState(() => quantity++)
                                            : null,
                                        borderRadius: const BorderRadius.horizontal(
                                          right: Radius.circular(8),
                                        ),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: quantity < 99 
                                                ? Colors.transparent
                                                : AppTheme.lightGray.withOpacity(0.5),
                                            borderRadius: const BorderRadius.horizontal(
                                              right: Radius.circular(8),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: quantity < 99 
                                                ? AppTheme.primaryBlue
                                                : AppTheme.mediumGray,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Observações
                          TextField(
                            controller: observationsController,
                            decoration: const InputDecoration(
                              labelText: 'Observações (opcional)',
                              hintText: 'Ex: sem cebola, ponto da carne, etc.',
                              prefixIcon: Icon(Icons.edit_note),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (quantity > 0) {
                              context.read<CartProvider>().addItem(
                                product,
                                quantity: quantity,
                                observations: observationsController.text.trim(),
                              );
                              
                              Navigator.of(context).pop();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} adicionado ao carrinho'),
                                  backgroundColor: AppTheme.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: const Text('Adicionar ao Carrinho'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}