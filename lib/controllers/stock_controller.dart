import 'package:flutter/material.dart';

import '../models/stock_model.dart';

/// Pure business logic for stock items: status rules, formatting,
/// aggregate calculations. Contains NO Flutter state / ChangeNotifier —
/// StockProvider calls into this, screens never call it directly for state.
class StockController {
  StockController._();

  /// Core rule requested by the assignment:
  /// currentStock < minStock  -> BELOW SAFE STOCK (red)
  /// currentStock within 15% above min -> NEAR THRESHOLD (orange)
  /// currentStock > 3x min -> OVERSTOCK (grey)
  /// otherwise -> SAFE STOCK (green)
  static StockStatus getStatus(StockItem item) {
    if (item.minStock <= 0) {
      return StockStatus.safe;
    }
    if (item.currentStock < item.minStock) {
      return StockStatus.belowSafe;
    }
    if (item.currentStock < item.minStock * 1.15) {
      return StockStatus.nearThreshold;
    }
    if (item.currentStock > item.minStock * 3) {
      return StockStatus.overstock;
    }
    return StockStatus.safe;
  }

  static String statusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.belowSafe:
        return 'BELOW SAFE STOCK';
      case StockStatus.nearThreshold:
        return 'NEAR THRESHOLD';
      case StockStatus.overstock:
        return 'OVERSTOCK';
      case StockStatus.safe:
        return 'SAFE STOCK';
    }
  }

  static Color statusColor(StockStatus status) {
    switch (status) {
      case StockStatus.belowSafe:
        return const Color(0xFFD32F2F);
      case StockStatus.nearThreshold:
        return const Color(0xFFE07A1F);
      case StockStatus.overstock:
        return const Color(0xFF6B6B6B);
      case StockStatus.safe:
        return const Color(0xFF3A7D2E);
    }
  }

  static Color statusBackground(StockStatus status) {
    switch (status) {
      case StockStatus.belowSafe:
        return const Color(0xFFFDEAEA);
      case StockStatus.nearThreshold:
        return const Color(0xFFFDEFE2);
      case StockStatus.overstock:
        return const Color(0xFFEFEFEF);
      case StockStatus.safe:
        return const Color(0xFFE9F5E6);
    }
  }

  /// Fraction of items that are NOT below safe stock, as a 0-100 percentage.
  static double safeStockPercentage(List<StockItem> items) {
    if (items.isEmpty) return 0;
    final safeCount = items
        .where((i) => getStatus(i) != StockStatus.belowSafe)
        .length;
    return safeCount / items.length * 100;
  }

  /// Days of runway left at the current pick rate. Returns null when the
  /// item isn't being depleted (pickRate >= 0).
  static double? daysBuffer(StockItem item) {
    if (item.pickRate >= 0) return null;
    return item.currentStock / item.pickRate.abs() / 24;
  }

  static int totalUnits(List<StockItem> items) =>
      items.fold(0, (sum, i) => sum + i.currentStock);

  static int criticalCount(List<StockItem> items) =>
      items.where((i) => getStatus(i) == StockStatus.belowSafe).length;
}
