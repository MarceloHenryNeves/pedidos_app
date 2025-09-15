class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final bool isActive;
  final String imageUrl;
  final String restaurantId;

  ProductModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.categoryId,
    this.isActive = true,
    this.imageUrl = '',
    required this.restaurantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'isActive': isActive,
      'imageUrl': imageUrl,
      'restaurantId': restaurantId,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      categoryId: map['categoryId'] ?? '',
      isActive: map['isActive'] ?? true,
      imageUrl: map['imageUrl'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    bool? isActive,
    String? imageUrl,
    String? restaurantId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, price: $price, categoryId: $categoryId, isActive: $isActive, imageUrl: $imageUrl, restaurantId: $restaurantId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductModel &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.price == price &&
      other.categoryId == categoryId &&
      other.isActive == isActive &&
      other.imageUrl == imageUrl &&
      other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      categoryId.hashCode ^
      isActive.hashCode ^
      imageUrl.hashCode ^
      restaurantId.hashCode;
  }
}