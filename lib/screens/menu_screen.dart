import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/table_model.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/category_list.dart';
import '../widgets/product_grid.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final TableModel table;

  const MenuScreen({
    super.key,
    required this.table,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      final cartProvider = context.read<CartProvider>();
      
      productProvider.refreshData();
      cartProvider.setTableId(widget.table.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softWhite,
      appBar: AppBar(
        title: Text('Mesa ${widget.table.number}'),
        elevation: 0.5,
        backgroundColor: AppTheme.primaryWhite,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      iconSize: 28,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CartScreen(table: widget.table),
                          ),
                        );
                      },
                    ),
                    if (cartProvider.itemCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.errorRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              color: AppTheme.primaryWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryBlue,
              ),
            );
          }

          if (productProvider.error != null) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: AppTheme.errorRed,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Erro ao carregar cardápio',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      productProvider.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        productProvider.clearError();
                        productProvider.refreshData();
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (productProvider.categories.isEmpty) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 40,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Cardápio em breve',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'As categorias e produtos serão carregados em breve',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Row(
            children: [
              Container(
                width: 240,
                color: AppTheme.primaryWhite,
                child: CategoryList(
                  categories: productProvider.categories,
                  selectedCategory: productProvider.selectedCategory,
                  onCategorySelected: productProvider.selectCategory,
                ),
              ),
              Container(
                width: 1,
                color: AppTheme.lightGray,
              ),
              Expanded(
                child: ProductGrid(
                  products: productProvider.filteredProducts,
                  table: widget.table,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            decoration: BoxDecoration(
              boxShadow: AppTheme.buttonShadow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartScreen(table: widget.table),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: AppTheme.primaryWhite,
              elevation: 0,
              label: Text(
                'Ver Carrinho (${cartProvider.itemCount})',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(Icons.shopping_cart),
            ),
          );
        },
      ),
    );
  }
}