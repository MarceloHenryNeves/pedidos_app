class CategoryModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final int order;
  final String restaurantId;

  CategoryModel({
    required this.id,
    required this.name,
    this.description = '',
    this.isActive = true,
    this.order = 0,
    required this.restaurantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'order': order,
      'restaurantId': restaurantId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActive: map['isActive'] ?? true,
      order: map['order']?.toInt() ?? 0,
      restaurantId: map['restaurantId'] ?? '',
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    int? order,
    String? restaurantId,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description, isActive: $isActive, order: $order, restaurantId: $restaurantId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CategoryModel &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.isActive == isActive &&
      other.order == order &&
      other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      isActive.hashCode ^
      order.hashCode ^
      restaurantId.hashCode;
  }
}