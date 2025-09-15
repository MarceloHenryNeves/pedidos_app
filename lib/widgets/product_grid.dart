import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/table_model.dart';
import '../theme/app_theme.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final TableModel table;

  const ProductGrid({
    super.key,
    required this.products,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
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
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.no_food,
                  size: 40,
                  color: AppTheme.mediumGray,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nenhum produto encontrado',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.darkGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Selecione outra categoria ou aguarde os produtos serem cadastrados',
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

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula o número de colunas baseado na largura disponível
          final crossAxisCount = (constraints.maxWidth / 280).floor().clamp(1, 4);
          
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.75,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                table: table,
              );
            },
          );
        },
      ),
    );
  }
}