class DeliveryBeneficiary {
  String id;
  String codeBeneficiary;
  String nameBeneficiary;
  String state;
  String idPhotoDelivery;
  DateTime? deliveryDate;
  DateTime updatedAt;
  String idDelivery;

  DeliveryBeneficiary({
    this.id = '',
    this.codeBeneficiary = '',
    this.nameBeneficiary = '',
    this.state = '',
    this.idPhotoDelivery = '',
    this.deliveryDate,
    DateTime? updatedAt,
    this.idDelivery = '',
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codeBeneficiary': codeBeneficiary,
      'nameBeneficiary': nameBeneficiary,
      'state': state,
      'idPhotoDelivery': idPhotoDelivery,
      'deliveryDate': deliveryDate?.toIso8601String().substring(0, 10),
      'updatedAt': updatedAt.toIso8601String(),
      'idDelivery': idDelivery,
    };
  }

  factory DeliveryBeneficiary.fromMap(Map<String, dynamic> map) {
    return DeliveryBeneficiary(
      id: map['id'] ?? '',
      codeBeneficiary: map['codeBeneficiary'] ?? '',
      nameBeneficiary: map['nameBeneficiary'] ?? '',
      state: map['state'] ?? '',
      idPhotoDelivery: map['idPhotoDelivery'] ?? '',
      deliveryDate: map['deliveryDate'] != null
          ? DateTime.parse(map['deliveryDate'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      idDelivery: map['idDelivery'] ?? '',
    );
  }

  DeliveryBeneficiary copyWith({
    String? id,
    String? codeBeneficiary,
    String? nameBeneficiary,
    String? state,
    String? idPhotoDelivery,
    DateTime? deliveryDate,
    DateTime? updatedAt,
    String? idDelivery,
  }) {
    return DeliveryBeneficiary(
      id: id ?? this.id,
      codeBeneficiary: codeBeneficiary ?? this.codeBeneficiary,
      nameBeneficiary: nameBeneficiary ?? this.nameBeneficiary,
      state: state ?? this.state,
      idPhotoDelivery: idPhotoDelivery ?? this.idPhotoDelivery,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      updatedAt: updatedAt ?? this.updatedAt,
      idDelivery: idDelivery ?? this.idDelivery,
    );
  }

  @override
  String toString() {
    return 'DeliveryBeneficiary{'
        'id: $id, '
        'codeBeneficiary: $codeBeneficiary, '
        'nameBeneficiary: $nameBeneficiary, '
        'state: $state, '
        'idPhotoDelivery: $idPhotoDelivery, '
        'deliveryDate: ${deliveryDate?.toIso8601String().substring(0, 10)}, '
        'updatedAt: ${updatedAt.toIso8601String()}, '
        'idDelivery: $idDelivery'
        '}';
  }
}
