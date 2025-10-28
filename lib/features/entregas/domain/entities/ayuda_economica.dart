class FinancialAid {
  String id;
  String idBenefit;
  String state; // Entregado, No Entregado
  String idDeliveryBeneficiary;

  FinancialAid({
    this.id = '',
    this.idBenefit = '',
    this.state = '',
    this.idDeliveryBeneficiary = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBenefit': idBenefit,
      'state': state,
      'idDeliveryBeneficiary': idDeliveryBeneficiary,
    };
  }

  factory FinancialAid.fromMap(Map<String, dynamic> map) {
    return FinancialAid(
      id: map['id'] ?? '',
      idBenefit: map['idBenefit'] ?? '',
      state: map['state'] ?? '',
      idDeliveryBeneficiary: map['idDeliveryBeneficiary'] ?? '',
    );
  }

  FinancialAid copyWith({
    String? id,
    String? idBenefit,
    String? state,
    String? idDeliveryBeneficiary,
  }) {
    return FinancialAid(
      id: id ?? this.id,
      idBenefit: idBenefit ?? this.idBenefit,
      state: state ?? this.state,
      idDeliveryBeneficiary:
          idDeliveryBeneficiary ?? this.idDeliveryBeneficiary,
    );
  }

  @override
  String toString() {
    return 'FinancialAid{'
        'id: $id, '
        'idBenefit: $idBenefit, '
        'state: $state, '
        'idDeliveryBeneficiary: $idDeliveryBeneficiary'
        '}';
  }

  // Métodos de conveniencia para el estado
  bool get isEntregado => state.toLowerCase() == 'entregado';
  bool get isNoEntregado => state.toLowerCase() == 'no entregado';

  void marcarComoEntregado() => state = 'Entregado';
  void marcarComoNoEntregado() => state = 'No Entregado';
}
