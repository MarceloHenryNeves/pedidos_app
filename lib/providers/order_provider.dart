import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../services/order_service.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _loading = false;
  String? _error;
  final String _restaurantId = 'default_restaurant';

  List<OrderModel> get orders => _orders;
  bool get loading => _loading;
  String? get error => _error;

  Future<String?> createOrder({
    required String tableId,
    required List<OrderItemModel> items,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final order = OrderModel(
        id: const Uuid().v4(),
        tableId: tableId,
        totalAmount: items.fold(0.0, (sum, item) => sum + item.subtotal),
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        restaurantId: _restaurantId,
        items: items,
      );
      
      final orderId = await OrderService.createOrder(order);
      await loadOrdersByTable(tableId);
      
      return orderId;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadOrdersByTable(String tableId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      _orders = await OrderService.getOrdersByTable(tableId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await OrderService.updateOrderStatus(orderId, status);
      
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: status,
          paidAt: status == OrderStatus.paid ? DateTime.now() : null,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> payTable(String tableId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await OrderService.payTable(tableId);
      _orders.clear();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  double getTableTotal(String tableId) {
    return _orders
        .where((order) => order.tableId == tableId && order.status == OrderStatus.confirmed)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  List<OrderModel> getOrdersByTable(String tableId) {
    return _orders
        .where((order) => order.tableId == tableId)
        .toList();
  }

  OrderModel? getOrder(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
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