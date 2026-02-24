
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int totalItems = 26;
    const int categories = 9;
    const int expired = 5;
    const int freshItems = 12;

    final List<Map<String, dynamic>> categoryData = [
      {'label': 'Food', 'value': 1, 'color': const Color(0xFF4285F4)},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
            ),
            _buildBottomNav(),
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
            style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Track your inventory insights',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ],
    );
  }

  // ─── Stats Grid ───────────────────────────────────────────
  Widget _buildStatsGrid(int total, int cats, int expired, int fresh) {
    final items = [
      {'icon': Icons.inventory_2_outlined,  'value': total,   'label': 'Total Items'},
      {'icon': Icons.trending_up_rounded,   'value': cats,    'label': 'Categories'},
      {'icon': Icons.timer_off_outlined,    'value': expired, 'label': 'Expired'},
      {'icon': Icons.check_circle_outline,  'value': fresh,   'label': 'Fresh Items'},
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
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
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
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 2),
        Text('${item['label']}',
        style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
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
    final total = expired + fresh;
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
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 130, height: 130,
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
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
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
        Container(width: 12, height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label $pct',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }

  // ─── Items by Category ────────────────────────────────────
  Widget _buildItemsByCategory(List<Map<String, dynamic>> data) {
    final maxVal = data.isEmpty
        ? 1
        : data.map((e) => e['value'] as int).reduce((a, b) => a > b ? a : b);

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
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),
          // Y-axis + bars
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
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 10));
                  }),
                ),
                const SizedBox(width: 8),
                // Bars
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: data.map((item) {
                      final pct = maxVal == 0 ? 0.0 : (item['value'] as int) / maxVal;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${item['value']}',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 120 * pct,
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(item['label'],
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
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

  // ─── Bottom Nav ───────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined,     'Home',     false),
          _navItem(Icons.bar_chart_rounded, 'Stats',    true),
          _navItem(Icons.settings_outlined, 'Settings', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    final color = isActive ? const Color(0xFF4285F4) : Colors.grey.shade400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
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
    canvas.drawArc(rect, startAngle, sweep, true,
    Paint()..color = seg['color'] as Color..style = PaintingStyle.fill);
    startAngle += sweep;
    }

    // خط فاصل أبيض زي الصورة
    final linePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2;
    canvas.drawLine(center,
    Offset(center.dx + radius, center.dy), linePaint);

    // Inner white circle
    canvas.drawCircle(center, radius * 0.001,
    Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PieChartPainter old) =>
      old.expiredPct != expiredPct || old.freshPct != freshPct;
}
