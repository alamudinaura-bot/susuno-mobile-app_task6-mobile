import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/stock_controller.dart';
import '../models/stock_model.dart';
import '../providers/stock_provider.dart';
import 'main_navigation.dart';
import 'widgets/app_drawer.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>();

    // No Scaffold/AppBar here — MainNavigationScreen owns the single shared
    // "SUSUNO" header, so it isn't duplicated per tab.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Stock Monitoring',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kSusunoGreen),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user, size: 14, color: kSusunoGreen),
                    SizedBox(width: 4),
                    Text(
                      'Audit Mode',
                      style: TextStyle(color: kSusunoGreen, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Floor Staff View \u2022 ${stock.totalActiveSku} Active SKUs',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search SKU, Product, Rack',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.qr_code_scanner),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Live stats: react instantly when a scan changes any item.
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.95,
            children: [
              _StatMini(
                icon: Icons.verified_outlined,
                label: 'Safe Stock',
                value: '${stock.safeStockPercentage.toStringAsFixed(1)}%',
              ),
              _StatMini(
                icon: Icons.move_to_inbox_outlined,
                label: 'Today Inflow',
                value: '+${stock.todayInbound}',
                color: Colors.green,
              ),
              _StatMini(
                icon: Icons.outbox_outlined,
                label: 'Today Outflow',
                value: '-${stock.todayOutbound}',
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stock.items.map((item) => _StockCard(item: item)),
        ],
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  const _StatMini({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color ?? Colors.grey.shade500),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final status = StockController.getStatus(item);
    final color = StockController.statusColor(status);
    final bg = StockController.statusBackground(status);
    final ratio = (item.currentStock / item.minStock).clamp(0, 1.5) / 1.5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  StockController.statusLabel(status),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item.sku,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Spacer(),
              const Icon(Icons.flag_outlined, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.grey,
              ),
              Expanded(
                child: Text(
                  item.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT FLOOR COUNT',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                  Text(
                    '${item.currentStock} Units',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SAFE MIN REQUIRED',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                  Text(
                    '${item.minStock} Units',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.toDouble(),
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.fact_check_outlined, size: 16),
                  label: const Text('Audit Count'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: kSusunoGreen),
                  onPressed: () {
                    // Load this SKU into the scanner and jump to that tab.
                    context.read<StockProvider>().selectItem(item.sku);
                    context.read<NavIndexProvider>().setIndex(2);
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 16),
                  label: const Text('Scan Bin'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
