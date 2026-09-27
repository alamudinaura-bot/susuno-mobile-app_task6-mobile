import 'package:flutter/material.dart';

class ChartSeries {
  final String label;
  final Color color;
  final List<double> values; // 0-100 scale, one per day label
  const ChartSeries({
    required this.label,
    required this.color,
    required this.values,
  });
}

/// A small area/line chart for the Dashboard's "Daily Task Tracking" card.
/// Kept as a self-contained CustomPainter so the project doesn't need an
/// extra chart dependency.
class MiniLineChart extends StatelessWidget {
  const MiniLineChart({
    super.key,
    required this.days,
    required this.series,
    this.height = 170,
  });

  final List<String> days;
  final List<ChartSeries> series;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _ChartPainter(series: series, days: days),
        child: Container(),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.series, required this.days});
  final List<ChartSeries> series;
  final List<String> days;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 26.0;
    const bottomPad = 20.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad;

    // Horizontal grid lines + y-axis labels (0/50/100).
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    final labelStyle = TextStyle(color: Colors.grey.shade500, fontSize: 9);
    for (final v in [0, 50, 100]) {
      final y = chartH - (v / 100) * chartH;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: '$v', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Day labels along the bottom.
    for (var i = 0; i < days.length; i++) {
      final x = leftPad + chartW * (i / (days.length - 1));
      final tp = TextPainter(
        text: TextSpan(text: days[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - tp.height));
    }

    for (final s in series) {
      final points = <Offset>[
        for (var i = 0; i < s.values.length; i++)
          Offset(
            leftPad + chartW * (i / (s.values.length - 1)),
            chartH - (s.values[i].clamp(0, 100) / 100) * chartH,
          ),
      ];

      // Filled area under the line.
      final fillPath = Path()..moveTo(points.first.dx, chartH);
      for (final p in points) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(points.last.dx, chartH);
      fillPath.close();
      canvas.drawPath(
        fillPath,
        Paint()..color = s.color.withValues(alpha: 0.12),
      );

      // Line itself.
      final linePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        linePath.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = s.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // Dots on each data point.
      final dotPaint = Paint()..color = s.color;
      for (final p in points) {
        canvas.drawCircle(p, 3, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.series != series || oldDelegate.days != days;
}
