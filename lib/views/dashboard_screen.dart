import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/stock_controller.dart';
import '../models/stock_model.dart';
import '../providers/stock_provider.dart';
import 'widgets/app_drawer.dart';
import 'widgets/mini_line_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>();

    // No Scaffold/AppBar here on purpose — MainNavigationScreen owns the
    // single shared "SUSUNO" header, so it never gets duplicated per tab.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search SKU, Product, Rack',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kSusunoGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _ShiftDeviceRow(),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.bar_chart, size: 18, color: kSusunoGreen),
              SizedBox(width: 6),
              Text(
                'Real-time Inventory Telemetry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.55,
            children: [
              _StatTile(
                label: 'Total Active SKU',
                value: '${stock.totalActiveSku}',
                icon: Icons.qr_code_2,
                trend: '+3.5% vs last week',
                trendColor: Colors.green,
              ),
              _StatTile(
                label: 'Total Stock Units',
                value: '${stock.totalStockUnits}',
                icon: Icons.widgets_outlined,
                trend: '+1.8%',
                trendColor: Colors.green,
              ),
              _StatTile(
                label: 'Total Inbound Today',
                value: '${stock.todayInbound}',
                icon: Icons.move_to_inbox_outlined,
                trend: 'On schedule',
                trendColor: Colors.green,
                pillColor: const Color(0xFFE9F5E6),
              ),
              _StatTile(
                label: 'Total Outbound Today',
                value: '${stock.todayOutbound}',
                icon: Icons.outbox_outlined,
                trend: 'Surge',
                trendColor: Colors.red,
                pillColor: const Color(0xFFFDEAEA),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CriticalStocksCard(count: stock.criticalStockCount),
              ),
              const SizedBox(width: 10),
              const Expanded(child: _PendingRestockCard()),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            icon: Icons.show_chart,
            title: 'Daily Task Tracking',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const MiniLineChart(
                  days: ['Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'],
                  series: [
                    ChartSeries(
                      label: 'Pending Putaway',
                      color: Color(0xFF3A7D2E),
                      values: [40, 78, 65, 20, 55, 15],
                    ),
                    ChartSeries(
                      label: 'Pending Outbound',
                      color: Color(0xFFE07A1F),
                      values: [55, 35, 85, 45, 55, 90],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Wrap(
                  spacing: 16,
                  children: [
                    _LegendDot(
                      color: Color(0xFF3A7D2E),
                      label: 'Pending Putaway',
                    ),
                    _LegendDot(
                      color: Color(0xFFE07A1F),
                      label: 'Pending Outbound',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 18,
                color: Color(0xFF6C4FD6),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'AI Insight & Operational Alerts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEAEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '2 Active',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Text(
            'Predictive telemetry & proactive stock safety',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const _AlertCard(
            tag: 'CRITICAL STOCKOUT ALERT',
            tagColor: Color(0xFFD32F2F),
            sku: 'SKU-8294',
            meta: '1.8 Days remaining buffer',
            title: 'Heavy-Duty Industrial Bearings 45mm',
            body:
                'Suggested AI Order: +1,200 units \u2022 Confidence 97%.\n'
                'Outbound velocity surged 24% over the last 14 days.',
            primaryLabel: 'Review',
            primaryColor: Color(0xFF3A7D2E),
            secondaryLabel: 'Dismiss',
          ),
          const SizedBox(height: 10),
          const _AlertCard(
            tag: 'VELOCITY ANOMALY',
            tagColor: Color(0xFFE07A1F),
            sku: 'SKU-3109',
            meta: '+180% Spike',
            title: 'High-Density Polyethylene Drum 200L',
            body:
                'Rapid barcode decrements detected without a matching '
                'sales order. Potential staging deviation.',
            primaryLabel: 'Flag audit',
            primaryColor: Color(0xFFD32F2F),
            secondaryLabel: 'Verify Dock Lead',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            icon: Icons.inventory_2_outlined,
            title: 'Critical Stock Monitoring',
            subtitle: 'Prioritized items requiring immediate lead intervention',
          ),
          const SizedBox(height: 10),
          ...stock.items.map((item) => _MonitoringCard(item: item)),
          const SizedBox(height: 24),
          const _SectionTitle(
            icon: Icons.folder_open_outlined,
            title: 'Pending Purchase Orders',
          ),
          const SizedBox(height: 10),
          const _PoCard(
            poNumber: 'PO-8821',
            tag: 'AI Generated',
            tagColor: Color(0xFF3A7D2E),
            vendor: 'Nippon Precision \u2022 1,200 units Bearings',
            amount: '\$38,400.00 USD',
          ),
          const SizedBox(height: 10),
          const _PoCard(
            poNumber: 'PO-8819',
            tag: 'Manual Req',
            tagColor: Color(0xFF3A6FD6),
            vendor: 'Apex Semiconductor \u2022 500 units MCUs',
            amount: '\$47,250.00 USD',
          ),
          const SizedBox(height: 10),
          const _PoCard(
            poNumber: 'PO-8815',
            tag: 'Urgent Buffer',
            tagColor: Color(0xFFD32F2F),
            vendor: 'EnerSys Power \u2022 100 units Forklift Cells',
            amount: '\$56,850.00 USD',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            icon: Icons.history,
            title: 'Warehouse Activity Audit Trail',
          ),
          const SizedBox(height: 10),
          const _AuditItem(
            color: Color(0xFF3A7D2E),
            title: 'SKU-9012 Scanned for Dispatch',
            time: '10:42 AM',
            body: '40 units transferred to Outbound Bay Dock 03.',
          ),
          const _AuditItem(
            color: Colors.blueGrey,
            title: 'Pallet Repositioning Execution',
            time: '10:31 AM',
            body: 'Rack B2-05-D to Overflow Bay 2 completed via AMR unit #04.',
          ),
          const _AuditItem(
            color: Color(0xFFD32F2F),
            title: 'Barcode Exception Triggered',
            time: '10:18 AM',
            body: 'Damaged QR code detected on SKU-3109 crate. Auto-routed to Quarantine Dock 02.',
          ),
        ],
      ),
    );
  }
}

class _ShiftDeviceRow extends StatelessWidget {
  const _ShiftDeviceRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundColor: kSusunoGreen,
          child: Icon(Icons.person, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Tabina Naila \u2022 Shift 1 (08:00 - 16:00)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            children: [
              Icon(Icons.smartphone, size: 12, color: kSusunoGreen),
              SizedBox(width: 4),
              Text('Zebra TC-57', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendColor,
    this.pillColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final String trend;
  final Color trendColor;
  final Color? pillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Icon(icon, size: 15, color: Colors.grey.shade400),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: pillColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trend,
              style: TextStyle(
                fontSize: 10,
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticalStocksCard extends StatelessWidget {
  const _CriticalStocksCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEAEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3B7B7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline, size: 16, color: Color(0xFFD32F2F)),
              SizedBox(width: 4),
              Text(
                'Critical Stocks',
                style: TextStyle(fontSize: 12, color: Color(0xFFD32F2F)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F),
            ),
          ),
          const Text(
            'Actions Required Immediately',
            style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F)),
          ),
        ],
      ),
    );
  }
}

class _PendingRestockCard extends StatelessWidget {
  const _PendingRestockCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Pending Restock',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '6 Orders',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Valuation \$142,500',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title, this.subtitle});
  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: kSusunoGreen),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 24),
            child: Text(
              subtitle!,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.tag,
    required this.tagColor,
    required this.sku,
    required this.meta,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.primaryColor,
    required this.secondaryLabel,
  });

  final String tag;
  final Color tagColor;
  final String sku;
  final String meta;
  final String title;
  final String body;
  final String primaryLabel;
  final Color primaryColor;
  final String secondaryLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: tagColor, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                sku,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                meta,
                style: TextStyle(
                  fontSize: 10,
                  color: tagColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {},
                  child: Text(primaryLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(secondaryLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One Critical Stock Monitoring card — reads live data from StockProvider
/// via the StockItem passed in, so scanning in/out updates this instantly.
class _MonitoringCard extends StatelessWidget {
  const _MonitoringCard({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final status = StockController.getStatus(item);
    final color = StockController.statusColor(status);
    final bg = StockController.statusBackground(status);
    final days = StockController.daysBuffer(item);
    final condensedLabel = switch (status) {
      StockStatus.belowSafe => 'CRITICAL',
      StockStatus.nearThreshold => 'LOW STOCK',
      StockStatus.overstock => 'OVERSTOCK',
      StockStatus.safe => 'SAFE',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4),
        ],
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
                  condensedLabel,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                item.sku,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            'Loc: ${item.location} \u2022 ${item.vendor}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric('STOCK', '${item.currentStock} Units', color),
              _metric('MIN SAFE', '${item.minStock} Units', Colors.black87),
              _metric(
                'DAYS LEFT',
                days == null ? '\u2014' : days.toStringAsFixed(1),
                color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _PoCard extends StatelessWidget {
  const _PoCard({
    required this.poNumber,
    required this.tag,
    required this.tagColor,
    required this.vendor,
    required this.amount,
  });

  final String poNumber;
  final String tag;
  final Color tagColor;
  final String vendor;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1EA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: kSusunoGreen,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      poNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tagColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: tagColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  vendor,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Details', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _AuditItem extends StatelessWidget {
  const _AuditItem({
    required this.color,
    required this.title,
    required this.time,
    required this.body,
  });
  final Color color;
  final String title;
  final String time;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Text(
                  body,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
