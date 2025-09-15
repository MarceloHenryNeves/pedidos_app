import 'order_item_model.dart';

enum OrderStatus { cart, confirmed, paid, cancelled }

class OrderModel {
  final String id;
  final String tableId;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String restaurantId;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.tableId,
    required this.totalAmount,
    this.status = OrderStatus.cart,
    required this.createdAt,
    this.paidAt,
    required this.restaurantId,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableId': tableId,
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'paidAt': paidAt?.millisecondsSinceEpoch,
      'restaurantId': restaurantId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      tableId: map['tableId'] ?? '',
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.cart,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      paidAt: map['paidAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['paidAt'])
          : null,
      restaurantId: map['restaurantId'] ?? '',
      items: [],
    );
  }

  OrderModel copyWith({
    String? id,
    String? tableId,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? paidAt,
    String? restaurantId,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
      restaurantId: restaurantId ?? this.restaurantId,
      items: items ?? this.items,
    );
  }

  double calculateTotal() {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, tableId: $tableId, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, paidAt: $paidAt, restaurantId: $restaurantId, items: ${items.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderModel &&
      other.id == id &&
      other.tableId == tableId &&
      other.totalAmount == totalAmount &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.paidAt == paidAt &&
      other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      tableId.hashCode ^
      totalAmount.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      paidAt.hashCode ^
      restaurantId.hashCode;
  }
}