import 'package:flutter/material.dart';
import '../models/order_item_model.dart';
import '../models/product_model.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final List<OrderItemModel> _items = [];
  String? _tableId;
  String? _error;

  List<OrderItemModel> get items => _items;
  String? get tableId => _tableId;
  String? get error => _error;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => _items.isEmpty;
  
  bool get isNotEmpty => _items.isNotEmpty;

  void setTableId(String tableId) {
    _tableId = tableId;
    notifyListeners();
  }

  void addItem(ProductModel product, {int quantity = 1, String observations = ''}) {
    print('CartProvider: Adicionando ${product.name} (ID: ${product.id})');
    
    final existingIndex = _items.indexWhere(
      (item) => item.productId == product.id && item.observations == observations
    );

    if (existingIndex >= 0) {
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        subtotal: (existingItem.quantity + quantity) * product.price,
      );
      print('CartProvider: Item existente atualizado - Nova qtd: ${_items[existingIndex].quantity}');
    } else {
      final itemId = const Uuid().v4();
      final newItem = OrderItemModel.fromProduct(
        id: itemId,
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: quantity,
        observations: observations,
        imageUrl: product.imageUrl,
      );
      _items.add(newItem);
      print('CartProvider: Novo item adicionado - ${newItem.productName} (Qtd: ${newItem.quantity})');
    }
    
    print('CartProvider: Total de itens no carrinho: ${_items.length}');
    notifyListeners();
  }

  void removeItem(String productId, {String observations = ''}) {
    _items.removeWhere(
      (item) => item.productId == productId && item.observations == observations
    );
    notifyListeners();
  }

  void updateItemQuantity(String productId, int newQuantity, {String observations = ''}) {
    if (newQuantity <= 0) {
      removeItem(productId, observations: observations);
      return;
    }

    final index = _items.indexWhere(
      (item) => item.productId == productId && item.observations == observations
    );

    if (index >= 0) {
      final item = _items[index];
      _items[index] = item.copyWith(
        quantity: newQuantity,
        subtotal: newQuantity * item.price,
      );
      notifyListeners();
    }
  }

  void updateItemObservations(String productId, String oldObservations, String newObservations) {
    final index = _items.indexWhere(
      (item) => item.productId == productId && item.observations == oldObservations
    );

    if (index >= 0) {
      _items[index] = _items[index].copyWith(observations: newObservations);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _tableId = null;
    _error = null;
    notifyListeners();
  }

  OrderItemModel? getItem(String productId, {String observations = ''}) {
    try {
      return _items.firstWhere(
        (item) => item.productId == productId && item.observations == observations
      );
    } catch (e) {
      return null;
    }
  }

  int getItemQuantity(String productId, {String observations = ''}) {
    final item = getItem(productId, observations: observations);
    return item?.quantity ?? 0;
  }

  bool hasItem(String productId, {String observations = ''}) {
    return getItem(productId, observations: observations) != null;
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void debugPrintCartState() {
    print('=== ESTADO COMPLETO DO CARRINHO ===');
    print('Total de itens: ${_items.length}');
    print('Total geral: $total');
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      print('Item [$i]: ${item.productName}');
      print('  - ID do produto: ${item.productId}');
      print('  - ID do item: ${item.id}');
      print('  - Preço unitário: R\$ ${item.price}');
      print('  - Quantidade: ${item.quantity}');
      print('  - Subtotal: R\$ ${item.subtotal}');
      print('  - Observações: "${item.observations}"');
    }
    print('=====================================');
  }
}