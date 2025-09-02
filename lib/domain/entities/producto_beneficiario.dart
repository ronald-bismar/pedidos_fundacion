class ProductBeneficiary {
  String id;
  String idProduct;
  String state;
  String idDeliveryBeneficiary;

  ProductBeneficiary({
    this.id = '',
    this.idProduct = '',
    this.state = '',
    this.idDeliveryBeneficiary = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codeBeneficiary': idProduct,
      'state': state,
      'idDelivery': idDeliveryBeneficiary,
    };
  }

  factory ProductBeneficiary.fromMap(Map<String, dynamic> map) {
    return ProductBeneficiary(
      id: map['id'] ?? '',
      idProduct: map['codeBeneficiary'] ?? '',
      state: map['state'] ?? '',
      idDeliveryBeneficiary: map['idDelivery'] ?? '',
    );
  }

  ProductBeneficiary copyWith({
    String? id,
    String? codeBeneficiary,
    String? nameBeneficiary,
    String? state,
    String? idPhotoDelivery,
    DateTime? deliveryDate,
    DateTime? updatedAt,
    String? idDelivery,
  }) {
    return ProductBeneficiary(
      id: id ?? this.id,
      idProduct: codeBeneficiary ?? idProduct,
      state: state ?? this.state,
      idDeliveryBeneficiary: idDelivery ?? idDeliveryBeneficiary,
    );
  }

  @override
  String toString() {
    return 'ProductBeneficiary{'
        'id: $id, '
        'codeBeneficiary: $idProduct, '
        'state: $state, '
        'idDelivery: $idDeliveryBeneficiary'
        '}';
  }
}
