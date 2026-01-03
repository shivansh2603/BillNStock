class BillItem {
  final int productId;
  final String name;
  final String unit;
  final double quantity;
  final double pricePerUnit;
  final double total;

  BillItem({
    required this.productId,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.pricePerUnit,
    required this.total,
  });
}
