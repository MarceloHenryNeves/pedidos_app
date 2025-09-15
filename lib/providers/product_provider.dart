import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/category_service.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  CategoryModel? _selectedCategory;
  bool _loading = false;
  String? _error;
  final String _restaurantId = 'default_restaurant';

  List<CategoryModel> get categories => _categories;
  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  CategoryModel? get selectedCategory => _selectedCategory;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _categories = await CategoryService.getCategories(_restaurantId);
      if (_categories.isNotEmpty && _selectedCategory == null) {
        selectCategory(_categories.first);
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _products = await ProductService.getProducts(_restaurantId);
      _filterProducts();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      _filteredProducts = await ProductService.getProductsByCategory(
        _restaurantId, 
        categoryId
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    _filterProducts();
    notifyListeners();
  }

  void _filterProducts() {
    if (_selectedCategory != null) {
      _filteredProducts = _products
          .where((product) => product.categoryId == _selectedCategory!.id)
          .toList();
    } else {
      _filteredProducts = List.from(_products);
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadCategories(),
      loadProducts(),
    ]);
  }

  ProductModel? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    if (value != null) {
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}