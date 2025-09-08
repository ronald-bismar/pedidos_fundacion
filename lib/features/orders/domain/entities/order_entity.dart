class Order {
  final String id;
  final String nameGroup;
  final String nameOrder;
  final DateTime dateOrder;
  final int numberBeneficiaries;

  Order({
    required this.id,
    required this.nameGroup,
    required this.nameOrder,
    required this.dateOrder,
    required this.numberBeneficiaries,
  });
}
