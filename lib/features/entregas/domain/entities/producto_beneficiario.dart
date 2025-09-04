class ProductBeneficiary {
  String idProductoBeneficiario;
  String idBeneficio;
  String estado; // Entregado, No Entregado
  String idEntregaBeneficiario;

  ProductBeneficiary({
    this.idProductoBeneficiario = '',
    this.idBeneficio = '',
    this.estado = '',
    this.idEntregaBeneficiario = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'idProductoBeneficiario': idProductoBeneficiario,
      'idBeneficio': idBeneficio,
      'estado': estado,
      'idEntregaBeneficiario': idEntregaBeneficiario,
    };
  }

  factory ProductBeneficiary.fromMap(Map<String, dynamic> map) {
    return ProductBeneficiary(
      idProductoBeneficiario: map['idProductoBeneficiario'] ?? '',
      idBeneficio: map['idBeneficio'] ?? '',
      estado: map['estado'] ?? '',
      idEntregaBeneficiario: map['idEntregaBeneficiario'] ?? '',
    );
  }

  ProductBeneficiary copyWith({
    String? idProductoBeneficiario,
    String? idBeneficio,
    String? estado,
    String? idEntregaBeneficiario,
  }) {
    return ProductBeneficiary(
      idProductoBeneficiario:
          idProductoBeneficiario ?? this.idProductoBeneficiario,
      idBeneficio: idBeneficio ?? this.idBeneficio,
      estado: estado ?? this.estado,
      idEntregaBeneficiario:
          idEntregaBeneficiario ?? this.idEntregaBeneficiario,
    );
  }

  @override
  String toString() {
    return 'ProductBeneficiary{'
        'idProductoBeneficiario: $idProductoBeneficiario, '
        'idBeneficio: $idBeneficio, '
        'estado: $estado, '
        'idEntregaBeneficiario: $idEntregaBeneficiario'
        '}';
  }

  // Métodos de conveniencia para el estado
  bool get isEntregado => estado.toLowerCase() == 'entregado';
  bool get isNoEntregado => estado.toLowerCase() == 'no entregado';

  void marcarComoEntregado() => estado = 'Entregado';
  void marcarComoNoEntregado() => estado = 'No Entregado';
}
