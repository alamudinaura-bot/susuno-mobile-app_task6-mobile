/// Status badge shown on Stock / Dashboard cards.
/// Computed from [StockItem.currentStock] vs [StockItem.minStock]
/// by StockController — never stored directly on the model.
enum StockStatus { belowSafe, nearThreshold, safe, overstock }

/// Plain data model. No business logic here — only fields.
/// Business rules (status, buffer days, etc) live in StockController.
class StockItem {
  final String sku;
  final String name;
  final String location; // e.g. "Rack A4-02-B \u2022 Bin 04 (Zone A)"
  final String vendor;
  final String barcode;
  final String lot;

  /// Current units physically on the floor. Mutable because scanning
  /// (stock in / stock out) updates it directly.
  int currentStock;

  /// Minimum safe quantity required for this SKU.
  final int minStock;

  /// Units per hour. Negative = being picked/outbound, positive = inbound.
  final double pickRate;

  StockItem({
    required this.sku,
    required this.name,
    required this.location,
    required this.vendor,
    required this.currentStock,
    required this.minStock,
    this.pickRate = 0,
    this.barcode = '',
    this.lot = '',
  });
}
