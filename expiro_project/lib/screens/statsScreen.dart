import 'package:flutter/material.dart';

import 'homeScreen.dart';

class StatsScreen extends StatelessWidget {
  final List<Item> items;

  const StatsScreen({super.key, required this.items}); // ← جديد

  @override
  Widget build(BuildContext context) {
    final int totalItems = items.length;
    final int expired    = items.where((e) => e.status == ItemStatus.expired).length;
    final int freshItems = items.where((e) => e.status == ItemStatus.fresh).length;
    final int categories = ProductType.values
        .where((t) => items.any((i) => i.type == t))
        .length;

    final List<Map<String, dynamic>> categoryData = ProductType.values
        .where((t) => items.any((i) => i.type == t))
        .map((t) => {
      'label': t.label,
      'value': items.where((i) => i.type == t).length,
      'color': const Color(0xFF4285F4),
    })
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStatsGrid(totalItems, categories, expired, freshItems),
            const SizedBox(height: 20),
            _buildStatusDistribution(expired, freshItems),
            const SizedBox(height: 20),
            _buildItemsByCategory(categoryData),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Statistics',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Track your inventory insights',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ],
    );
  }

  // ─── Stats Grid ───────────────────────────────────────────
  Widget _buildStatsGrid(int total, int cats, int expired, int fresh) {
    final gridItems = [
      {'icon': Icons.inventory_2_outlined, 'value': total,   'label': 'Total Items'},
      {'icon': Icons.trending_up_rounded,  'value': cats,    'label': 'Categories'},
      {'icon': Icons.timer_off_outlined,   'value': expired, 'label': 'Expired'},
      {'icon': Icons.check_circle_outline, 'value': fresh,   'label': 'Fresh Items'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: gridItems.length,
      itemBuilder: (_, i) {
        final item = gridItems[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(item['icon'] as IconData, color: Colors.black54, size: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item['value']}',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('${item['label']}',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 10)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Status Distribution ──────────────────────────────────
  Widget _buildStatusDistribution(int expired, int fresh) {
    final total      = expired + fresh;
    final expiredPct = total == 0 ? 0.0 : expired / total;
    final freshPct   = total == 0 ? 0.0 : fresh / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status Distribution',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CustomPaint(
                  painter: _PieChartPainter(
                    expiredPct: expiredPct,
                    freshPct: freshPct,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (expiredPct > 0)
                    _legendItem(const Color(0xFFE53935), 'Expired',
                        '${(expiredPct * 100).toStringAsFixed(0)}%'),
                  const SizedBox(height: 10),
                  if (freshPct > 0)
                    _legendItem(const Color(0xFF43A047), 'Fresh',
                        '${(freshPct * 100).toStringAsFixed(0)}%'),
                  if (total == 0)
                    Text('No data',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String pct) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label $pct',
            style:
            TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }

  // ─── Items by Category ────────────────────────────────────
  Widget _buildItemsByCategory(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Text('No data yet',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
        ),
      );
    }

    final maxVal = data.map((e) => e['value'] as int).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Items by Category',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(4, (i) {
                    final val = ((maxVal / 3) * (3 - i)).round();
                    return Text('$val',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 10));
                  }),
                ),
                const SizedBox(width: 8),
                // Bars
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: data.map((item) {
                      final pct = maxVal == 0
                          ? 0.0
                          : (item['value'] as int) / maxVal;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${item['value']}',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10)),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 120 * pct,
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(item['label'],
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pie Chart Painter ────────────────────────────────────
class _PieChartPainter extends CustomPainter {
  final double expiredPct;
  final double freshPct;

  _PieChartPainter({required this.expiredPct, required this.freshPct});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect   = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -1.5708;

    final segments = [
      {'pct': expiredPct, 'color': const Color(0xFFE53935)},
      {'pct': freshPct,   'color': const Color(0xFF43A047)},
    ];

    for (final seg in segments) {
      final pct = seg['pct'] as double;
      if (pct <= 0) continue;
      final sweep = pct * 6.2832;
      canvas.drawArc(
          rect,
          startAngle,
          sweep,
          true,
          Paint()
            ..color = seg['color'] as Color
            ..style = PaintingStyle.fill);
      startAngle += sweep;
    }

    canvas.drawLine(
        center,
        Offset(center.dx + radius, center.dy),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2);

    // Inner white circle
    canvas.drawCircle(
        center, radius * 0.001, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PieChartPainter old) =>
      old.expiredPct != expiredPct || old.freshPct != freshPct;
}