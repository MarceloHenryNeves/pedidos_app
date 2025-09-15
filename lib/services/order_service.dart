import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import 'firebase_service.dart';
import 'table_service.dart';

class OrderService {
  static Future<String> createOrder(OrderModel order) async {
    try {
      print('OrderService: Criando pedido para mesa ${order.tableId}');
      
      final docRef = FirebaseService.orders.doc();
      final orderWithId = order.copyWith(id: docRef.id);
      
      await docRef.set(orderWithId.toMap());
      await _saveOrderItems(docRef.id, order.items);
      
      await TableService.updateTableTotal(
        order.tableId, 
        await _calculateTableTotal(order.tableId)
      );
      
      print('OrderService: Pedido criado com sucesso: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('OrderService: Erro ao criar pedido: $e');
      throw Exception('Erro ao criar pedido: $e');
    }
  }

  static Future<void> _saveOrderItems(String orderId, List<OrderItemModel> items) async {
    try {
      final batch = FirebaseService.firestore.batch();
      
      for (final item in items) {
        final itemRef = FirebaseService.orders
            .doc(orderId)
            .collection(FirebaseService.orderItemsCollection)
            .doc();
        
        final itemWithId = item.copyWith(id: itemRef.id);
        batch.set(itemRef, itemWithId.toMap());
      }
      
      await batch.commit();
    } catch (e) {
      print('OrderService: Erro ao salvar itens: $e');
      throw Exception('Erro ao salvar itens do pedido: $e');
    }
  }

  static Future<List<OrderModel>> getOrdersByTable(String tableId) async {
    try {
      final querySnapshot = await FirebaseService.orders
          .where('tableId', isEqualTo: tableId)
          .where('status', isEqualTo: OrderStatus.confirmed.name)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = <OrderModel>[];
      
      for (final doc in querySnapshot.docs) {
        final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        final items = await _getOrderItems(doc.id);
        orders.add(order.copyWith(items: items));
      }
      
      return orders;
    } catch (e) {
      throw Exception('Erro ao carregar pedidos da mesa: $e');
    }
  }

  static Future<List<OrderItemModel>> _getOrderItems(String orderId) async {
    try {
      final querySnapshot = await FirebaseService.orders
          .doc(orderId)
          .collection(FirebaseService.orderItemsCollection)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderItemModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar itens do pedido: $e');
    }
  }

  static Future<double> _calculateTableTotal(String tableId) async {
    try {
      final orders = await getOrdersByTable(tableId);
      return orders.fold<double>(0.0, (total, order) => total + order.totalAmount);
    } catch (e) {
      return 0.0;
    }
  }

  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final updateData = <String, dynamic>{
        'status': status.name,
      };
      
      if (status == OrderStatus.paid) {
        updateData['paidAt'] = FieldValue.serverTimestamp();
      }
      
      await FirebaseService.orders.doc(orderId).update(updateData);
    } catch (e) {
      throw Exception('Erro ao atualizar status do pedido: $e');
    }
  }

  static Future<void> payTable(String tableId) async {
    try {
      final orders = await getOrdersByTable(tableId);
      
      final batch = FirebaseService.firestore.batch();
      
      for (final order in orders) {
        final orderRef = FirebaseService.orders.doc(order.id);
        batch.update(orderRef, {
          'status': OrderStatus.paid.name,
          'paidAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      
      await TableService.resetTable(tableId);
    } catch (e) {
      throw Exception('Erro ao processar pagamento da mesa: $e');
    }
  }

  static Stream<List<OrderModel>> getOrdersByTableStream(String tableId) {
    return FirebaseService.orders
        .where('tableId', isEqualTo: tableId)
        .where('status', isEqualTo: OrderStatus.confirmed.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final orders = <OrderModel>[];
          
          for (final doc in snapshot.docs) {
            final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
            final items = await _getOrderItems(doc.id);
            orders.add(order.copyWith(items: items));
          }
          
          return orders;
        });
  }

  static Future<OrderModel?> getOrder(String orderId) async {
    try {
      final doc = await FirebaseService.orders.doc(orderId).get();
      if (doc.exists) {
        final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        final items = await _getOrderItems(orderId);
        return order.copyWith(items: items);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar pedido: $e');
    }
  }
}