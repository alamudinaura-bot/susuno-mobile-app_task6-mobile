import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/stock_controller.dart';
import '../providers/stock_provider.dart';
import 'widgets/app_drawer.dart';

/// Purely visual scan-mode tabs from the mock. Kept as local widget state
/// (not global) since switching it doesn't need to be shared across screens.
enum ScanMode { singleScan, batchCount, putaway }

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  ScanMode _mode = ScanMode.singleScan;

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>();
    final item = stock.selectedItem;
    final status = StockController.getStatus(item);

    // No Scaffold/AppBar here — MainNavigationScreen owns the single shared
    // "SUSUNO" header, so it isn't duplicated per tab.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SIMS Floor Scan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Physical Audit Protocol',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 14),

          // Scan-mode tabs matching the Figma mock (Single Scan / Batch
          // Count / Putaway). Visual only — the actual count/save flow
          // below works the same in every mode.
          Row(
            children: [
              Expanded(
                child: _ScanModeTab(
                  label: 'Single Scan',
                  icon: Icons.qr_code_scanner,
                  selected: _mode == ScanMode.singleScan,
                  onTap: () => setState(() => _mode = ScanMode.singleScan),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ScanModeTab(
                  label: 'Batch Count',
                  icon: Icons.grid_view_rounded,
                  selected: _mode == ScanMode.batchCount,
                  onTap: () => setState(() => _mode = ScanMode.batchCount),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ScanModeTab(
                  label: 'Putaway',
                  icon: Icons.compare_arrows,
                  selected: _mode == ScanMode.putaway,
                  onTap: () => setState(() => _mode = ScanMode.putaway),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lets the floor staff pick which SKU they're scanning, instead
          // of always defaulting to the first item in the list.
          const Text(
            'Scanning Item',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: item.sku,
                icon: const Icon(Icons.expand_more),
                onChanged: (sku) {
                  if (sku != null) {
                    context.read<StockProvider>().selectItem(sku);
                  }
                },
                items: stock.items
                    .map(
                      (i) => DropdownMenuItem(
                        value: i.sku,
                        child: Text(
                          '${i.sku} \u2014 ${i.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stock In / Stock Out toggle — drives which counter confirm() updates.
          Row(
            children: [
              Expanded(
                child: _ModeButton(
                  label: 'STOCK IN',
                  icon: Icons.move_to_inbox_outlined,
                  color: Colors.green,
                  selected: stock.transactionType == TransactionType.stockIn,
                  onTap: () => context.read<StockProvider>().setTransactionType(
                    TransactionType.stockIn,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeButton(
                  label: 'STOCK OUT',
                  icon: Icons.outbox_outlined,
                  color: Colors.red,
                  selected: stock.transactionType == TransactionType.stockOut,
                  onTap: () => context.read<StockProvider>().setTransactionType(
                    TransactionType.stockOut,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Advanced UI requirement: Stack for the camera viewfinder overlay.
          AspectRatio(
            aspectRatio: 1.1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10130F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFB9E14A),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'ALIGN CODE WITHIN RETICLE',
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    'Targeting: ${item.sku}',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
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
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Hardware Scan Verified',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.sku,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(item.name, style: const TextStyle(fontSize: 15)),
                Text(
                  'Barcode: ${item.barcode}  \u2022  Lot #${item.lot}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Text(
                  'Location: ${item.location}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text(
                  'Quantity to record',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundIconButton(
                      icon: Icons.remove,
                      onTap: () => context.read<StockProvider>().decrementQty(),
                    ),
                    Container(
                      width: 90,
                      alignment: Alignment.center,
                      child: Text(
                        '${stock.pendingQty}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _RoundIconButton(
                      icon: Icons.add,
                      onTap: () => context.read<StockProvider>().incrementQty(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [1, 5, 10].map((n) {
                    return OutlinedButton(
                      onPressed: () =>
                          context.read<StockProvider>().incrementQty(n),
                      child: Text('+$n'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: kSusunoGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.read<StockProvider>().confirmTransaction();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${StockController.statusLabel(status)} \u2014 ${item.name} now ${item.currentStock} units',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Confirm Physical Count & Save'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange.shade800,
              ),
              onPressed: () =>
                  _showMismatchReportDialog(context, item.sku, item.name),
              icon: const Icon(Icons.warning_amber_outlined),
              label: const Text('Report Quantity Mismatch / Damage'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when the floor staff taps "Report Quantity Mismatch / Damage".
/// Purely a UI confirmation for now — wire this into a real
/// notification/ticketing call whenever that backend exists.
void _showMismatchReportDialog(
  BuildContext context,
  String sku,
  String itemName,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(
        Icons.mark_email_read_outlined,
        color: kSusunoGreen,
        size: 36,
      ),
      title: const Text('Report Sent to Manager'),
      content: Text(
        'Your quantity mismatch / damage report for $sku \u2014 $itemName has been '
        'sent to your shift manager for review.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kSusunoGreen),
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class _ScanModeTab extends StatelessWidget {
  const _ScanModeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kSusunoGreen.withValues(alpha: 0.1) : Colors.white,
          border: Border.all(
            color: selected ? kSusunoGreen : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: selected ? kSusunoGreen : Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: selected ? kSusunoGreen : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.white,
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
