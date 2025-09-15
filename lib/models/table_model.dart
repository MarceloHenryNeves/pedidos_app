class TableModel {
  final String id;
  final int number;
  final double currentTotal;
  final bool isOccupied;
  final DateTime? lastOrderTime;
  final String restaurantId;

  TableModel({
    required this.id,
    required this.number,
    this.currentTotal = 0.0,
    this.isOccupied = false,
    this.lastOrderTime,
    required this.restaurantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'currentTotal': currentTotal,
      'isOccupied': isOccupied,
      'lastOrderTime': lastOrderTime?.millisecondsSinceEpoch,
      'restaurantId': restaurantId,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'] ?? '',
      number: map['number']?.toInt() ?? 0,
      currentTotal: map['currentTotal']?.toDouble() ?? 0.0,
      isOccupied: map['isOccupied'] ?? false,
      lastOrderTime: map['lastOrderTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastOrderTime'])
          : null,
      restaurantId: map['restaurantId'] ?? '',
    );
  }

  TableModel copyWith({
    String? id,
    int? number,
    double? currentTotal,
    bool? isOccupied,
    DateTime? lastOrderTime,
    String? restaurantId,
  }) {
    return TableModel(
      id: id ?? this.id,
      number: number ?? this.number,
      currentTotal: currentTotal ?? this.currentTotal,
      isOccupied: isOccupied ?? this.isOccupied,
      lastOrderTime: lastOrderTime ?? this.lastOrderTime,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  String toString() {
    return 'TableModel(id: $id, number: $number, currentTotal: $currentTotal, isOccupied: $isOccupied, lastOrderTime: $lastOrderTime, restaurantId: $restaurantId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TableModel &&
      other.id == id &&
      other.number == number &&
      other.currentTotal == currentTotal &&
      other.isOccupied == isOccupied &&
      other.lastOrderTime == lastOrderTime &&
      other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      number.hashCode ^
      currentTotal.hashCode ^
      isOccupied.hashCode ^
      lastOrderTime.hashCode ^
      restaurantId.hashCode;
  }
}