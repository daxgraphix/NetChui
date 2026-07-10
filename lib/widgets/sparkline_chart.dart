import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class SparklineChart extends StatefulWidget {
  const SparklineChart({
    super.key,
    required this.values,
    this.height = 56,
    this.accent = AppColors.red,
  });

  final List<double> values;
  final double height;
  final Color accent;

  @override
  State<SparklineChart> createState() => _SparklineChartState();
}

class _SparklineChartState extends State<SparklineChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.values.length < 2) return const SizedBox.shrink();

    return Semantics(
      label: 'Download speed trend chart',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanUpdate: (details) => _handleTouch(details.localPosition, constraints.maxWidth),
            onPanStart: (details) => _handleTouch(details.localPosition, constraints.maxWidth),
            onPanEnd: (_) => setState(() => _selectedIndex = null),
            onTapDown: (details) => _handleTouch(details.localPosition, constraints.maxWidth),
            onTapUp: (_) => setState(() => _selectedIndex = null),
            child: MouseRegion(
              onHover: (event) => _handleTouch(event.localPosition, constraints.maxWidth),
              onExit: (_) => setState(() => _selectedIndex = null),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: widget.height,
                      width: double.infinity,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _SparklinePainter(
                            values: widget.values,
                            accent: widget.accent,
                            selectedIndex: _selectedIndex,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedIndex != null && _selectedIndex! < widget.values.length)
                    Positioned(
                      left: (_selectedIndex! / (widget.values.length - 1) * constraints.maxWidth) - 40,
                      top: 0,
                      child: Container(
                        width: 80,
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.values[_selectedIndex!].toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleTouch(Offset localPosition, double width) {
    final step = width / (widget.values.length - 1);
    final index = (localPosition.dx / step).round().clamp(0, widget.values.length - 1);
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.accent,
    this.selectedIndex,
  });

  final List<double> values;
  final Color accent;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min).clamp(0.1, double.infinity);

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height -
          ((values[i] - min) / range) * (size.height - 8) -
          4;
      points.add(Offset(x, y));
    }

    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [accent.withValues(alpha: 0.2), accent.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < points.length; i++) {
      final isSelected = i == selectedIndex;
      canvas.drawCircle(
        points[i],
        isSelected ? 5 : 3,
        Paint()..color = isSelected ? accent : accent.withValues(alpha: 0.5),
      );
      if (isSelected) {
        canvas.drawCircle(
          points[i],
          8,
          Paint()
            ..color = accent.withValues(alpha: 0.2)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) {
    return old.values != values || old.selectedIndex != selectedIndex;
  }
}
