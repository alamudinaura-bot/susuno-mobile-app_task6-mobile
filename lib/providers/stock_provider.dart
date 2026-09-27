import 'package:flutter/foundation.dart';

import '../controllers/stock_controller.dart';
import '../models/stock_model.dart';

enum TransactionType { stockIn, stockOut }

/// Single source of truth shared by DashboardScreen, StockScreen and
/// ScannerScreen. Wrap the app in `ChangeNotifierProvider(create: (_) =>
/// StockProvider())` in main.dart and read it with `context.watch` /
/// `Provider.of` / `Consumer<StockProvider>` in the screens.
class StockProvider extends ChangeNotifier {
  StockProvider() {
    _selectedSku = _items.first.sku;
  }

  final List<StockItem> _items = [
    StockItem(
      sku: 'SKU-9294',
      name: 'Industrial Bearings 45mm',
      location: 'Rack A4-02-B \u2022 Bin 04 (Zone A)',
      vendor: 'Nippon Precision Corp',
      barcode: '78041908241',
      lot: '088-A',
      currentStock: 142,
      minStock: 500,
      pickRate: -18.4,
    ),
    StockItem(
      sku: 'SKU-5531',
      name: 'Micro-Controller Integrated Board v2',
      location: 'Rack C3-08-B \u2022 Bin 10 (Zone C)',
      vendor: 'Apex Semiconductor',
      currentStock: 380,
      minStock: 450,
      pickRate: -6.2,
    ),
    StockItem(
      sku: 'SKU-7625',
      name: 'Lithium-Ion Battery Pack 48v',
      location: 'Rack D11-65-D \u2022 Bin 18 (Haznat Compilant)',
      vendor: 'EnerSys Power',
      currentStock: 640,
      minStock: 525,
      pickRate: 4.0,
    ),
    StockItem(
      sku: 'SKU-6390',
      name: 'Hydraulic Seal Gasket Nitrile',
      location: 'Rack E3-01-A \u2022 Bin 08 (Bulk Zone)',
      vendor: 'Polymer Dynamics',
      currentStock: 7284,
      minStock: 2000,
      pickRate: 1.5,
    ),
  ];

  int _todayInbound = 12450;
  int _todayOutbound = 15820;

  late String _selectedSku;
  int _pendingQty = 1;
  TransactionType _transactionType = TransactionType.stockIn;

  // ---- Read-only getters consumed by the UI ----
  List<StockItem> get items => List.unmodifiable(_items);
  int get todayInbound => _todayInbound;
  int get todayOutbound => _todayOutbound;
  int get pendingQty => _pendingQty;
  TransactionType get transactionType => _transactionType;

  StockItem get selectedItem => _items.firstWhere(
    (i) => i.sku == _selectedSku,
    orElse: () => _items.first,
  );

  double get safeStockPercentage => StockController.safeStockPercentage(_items);
  int get totalActiveSku => _items.length;
  int get totalStockUnits => StockController.totalUnits(_items);
  int get criticalStockCount => StockController.criticalCount(_items);

  // ---- Actions ----

  /// Called from the Stock screen ("Scan Bin") or Dashboard to load a SKU
  /// into the scanner.
  void selectItem(String sku) {
    _selectedSku = sku;
    _pendingQty = 1;
    notifyListeners();
  }

  void setTransactionType(TransactionType type) {
    _transactionType = type;
    notifyListeners();
  }

  void incrementQty([int by = 1]) {
    _pendingQty += by;
    notifyListeners();
  }

  void decrementQty([int by = 1]) {
    _pendingQty = (_pendingQty - by).clamp(0, 999999);
    notifyListeners();
  }

  /// Applies the pending quantity to the selected item and to the
  /// dashboard's inbound/outbound counters, then resets the counter.
  /// This is what makes Scanner -> Dashboard and Scanner -> Stock reactive.
  void confirmTransaction() {
    if (_pendingQty <= 0) return;
    final item = selectedItem;

    if (_transactionType == TransactionType.stockIn) {
      item.currentStock += _pendingQty;
      _todayInbound += _pendingQty;
    } else {
      item.currentStock = (item.currentStock - _pendingQty).clamp(0, 1 << 30);
      _todayOutbound += _pendingQty;
    }

    _pendingQty = 1;
    notifyListeners();
  }
}
