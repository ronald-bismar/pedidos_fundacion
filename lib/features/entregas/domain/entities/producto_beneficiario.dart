class ProductBeneficiary {
  String id;
  String idBenefit;
  String state; // Entregado, No Entregado
  String idDeliveryBeneficiary;

  ProductBeneficiary({
    this.id = '',
    this.idBenefit = '',
    this.state = '',
    this.idDeliveryBeneficiary = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'idProductoBeneficiario': id,
      'idBeneficio': idBenefit,
      'estado': state,
      'idEntregaBeneficiario': idDeliveryBeneficiary,
    };
  }

  factory ProductBeneficiary.fromMap(Map<String, dynamic> map) {
    return ProductBeneficiary(
      id: map['idProductoBeneficiario'] ?? '',
      idBenefit: map['idBeneficio'] ?? '',
      state: map['estado'] ?? '',
      idDeliveryBeneficiary: map['idEntregaBeneficiario'] ?? '',
    );
  }

  ProductBeneficiary copyWith({
    String? idProductoBeneficiario,
    String? idBeneficio,
    String? estado,
    String? idEntregaBeneficiario,
  }) {
    return ProductBeneficiary(
      id: idProductoBeneficiario ?? this.id,
      idBenefit: idBeneficio ?? this.idBenefit,
      state: estado ?? this.state,
      idDeliveryBeneficiary:
          idEntregaBeneficiario ?? this.idDeliveryBeneficiary,
    );
  }

  @override
  String toString() {
    return 'ProductBeneficiary{'
        'idProductoBeneficiario: $id, '
        'idBeneficio: $idBenefit, '
        'estado: $state, '
        'idEntregaBeneficiario: $idDeliveryBeneficiary'
        '}';
  }

  // Métodos de conveniencia para el estado
  bool get isEntregado => state.toLowerCase() == 'entregado';
  bool get isNoEntregado => state.toLowerCase() == 'no entregado';

  void marcarComoEntregado() => state = 'Entregado';
  void marcarComoNoEntregado() => state = 'No Entregado';
}
