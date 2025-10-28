class Delivery {
  String id;
  String nameDelivery;
  DateTime scheduledDate;
  String idGroup;
  String nameGroup;
  String foundation;
  DateTime updatedAt;
  String type;
  String idCoordinator;

  Delivery({
    this.id = '',
    this.nameDelivery = '',
    required this.scheduledDate,
    this.idGroup = '',
    this.nameGroup = '',
    this.foundation = '',
    DateTime? updatedAt,
    this.type = '',
    this.idCoordinator = '',
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameDelivery': nameDelivery,
      'deliveryDate': scheduledDate.toIso8601String().substring(0, 10),
      'idGroup': idGroup,
      'nameGroup': nameGroup,
      'foundation': foundation,
      'updatedAt': updatedAt.toIso8601String(),
      'type': type,
      'idCoordinator': idCoordinator,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'] ?? '',
      nameDelivery: map['nameDelivery'] ?? '',
      scheduledDate: map['deliveryDate'] != null
          ? DateTime.parse(map['deliveryDate'])
          : DateTime.now(),
      idGroup: map['idGroup'] ?? '',
      nameGroup: map['nameGroup'] ?? '',
      foundation: map['foundation'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      type: map['type'] ?? '',
      idCoordinator: map['idCoordinator'] ?? '',
    );
  }

  Delivery copyWith({
    String? id,
    String? nameDelivery,
    DateTime? deliveryDate,
    String? idGroup,
    String? nameGroup,
    String? foundation,
    DateTime? updatedAt,
    String? type,
    String? idCoordinator,
  }) {
    return Delivery(
      id: id ?? this.id,
      nameDelivery: nameDelivery ?? this.nameDelivery,
      scheduledDate: deliveryDate ?? this.scheduledDate,
      idGroup: idGroup ?? this.idGroup,
      nameGroup: nameGroup ?? this.nameGroup,
      foundation: foundation ?? this.foundation,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      idCoordinator: idCoordinator ?? this.idCoordinator,
    );
  }

  @override
  String toString() {
    return 'Delivery{'
        'id: $id, '
        'nameDelivery: $nameDelivery, '
        'deliveryDate: ${scheduledDate.toIso8601String().substring(0, 10)}, '
        'idGroup: $idGroup, '
        'nameGroup: $nameGroup, '
        'foundation: $foundation, '
        'updatedAt: ${updatedAt.toIso8601String()}, '
        'type: $type, '
        'idCoordinator: $idCoordinator'
        '}';
  }
}
