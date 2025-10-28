class Benefit {
  String id;
  String type;
  String description;
  String idDelivery;
  DateTime updatedAt;

  Benefit({
    this.id = '',
    this.type = '',
    this.description = '',
    this.idDelivery = '',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'idDelivery': idDelivery,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Benefit.fromMap(Map<String, dynamic> map) {
    return Benefit(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      idDelivery: map['idDelivery'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  Benefit copyWith({
    String? id,
    String? type,
    String? description,
    String? idDelivery,
    DateTime? updatedAt,
  }) {
    return Benefit(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      idDelivery: idDelivery ?? this.idDelivery,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Benefit{'
        'id: $id, '
        'type: $type, '
        'description: $description, '
        'idDelivery: $idDelivery, '
        'updatedAt: ${updatedAt.toIso8601String()}'
        '}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Benefit &&
        other.id == id &&
        other.type == type &&
        other.description == description &&
        other.idDelivery == idDelivery &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        description.hashCode ^
        idDelivery.hashCode ^
        updatedAt.hashCode;
  }
}
