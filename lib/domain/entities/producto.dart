class Product {
  String id;
  String nameProduct;
  DateTime updatedAt;

  Product({this.id = '', this.nameProduct = '', DateTime? updatedAt})
    : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codeBeneficiary': nameProduct,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      nameProduct: map['codeBeneficiary'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  Product copyWith({String? id, String? nameProduct, DateTime? updatedAt}) {
    return Product(
      id: id ?? this.id,
      nameProduct: nameProduct ?? this.nameProduct,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product{'
        'id: $id, '
        'codeBeneficiary: $nameProduct, '
        'updatedAt: ${updatedAt.toIso8601String()}, '
        '}';
  }
}
