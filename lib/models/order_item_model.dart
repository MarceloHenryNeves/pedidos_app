class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String observations;
  final double subtotal;
  final String imageUrl;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.observations = '',
    required this.subtotal,
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'observations': observations,
      'subtotal': subtotal,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      subtotal: map['subtotal']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  OrderItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? observations,
    double? subtotal,
    String? imageUrl,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      observations: observations ?? this.observations,
      subtotal: subtotal ?? this.subtotal,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory OrderItemModel.fromProduct({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
    String observations = '',
    String imageUrl = '',
    String? id,
  }) {
    return OrderItemModel(
      id: id ?? '',
      productId: productId,
      productName: productName,
      price: price,
      quantity: quantity,
      observations: observations,
      subtotal: price * quantity,
      imageUrl: imageUrl,
    );
  }

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productId: $productId, productName: $productName, price: $price, quantity: $quantity, observations: $observations, subtotal: $subtotal, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderItemModel &&
      other.id == id &&
      other.productId == productId &&
      other.productName == productName &&
      other.price == price &&
      other.quantity == quantity &&
      other.observations == observations &&
      other.subtotal == subtotal &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      productId.hashCode ^
      productName.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      observations.hashCode ^
      subtotal.hashCode ^
      imageUrl.hashCode;
  }
}