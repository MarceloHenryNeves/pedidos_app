import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../theme/app_theme.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final Function(CategoryModel) onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Categorias',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.darkGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Lista de categorias
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory?.id == category.id;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primaryBlue 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                      ? null 
                      : Border.all(
                          color: AppTheme.lightGray,
                          width: 1,
                        ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onCategorySelected(category),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? AppTheme.primaryWhite
                                  : AppTheme.darkGray,
                            ),
                          ),
                          if (category.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              category.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                                    ? AppTheme.primaryWhite.withOpacity(0.8)
                                    : AppTheme.mediumGray,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}