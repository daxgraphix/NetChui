import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class SpeedGauge extends StatefulWidget {
  const SpeedGauge({
    super.key,
    required this.valueMbps,
    required this.progress,
    required this.isRunning,
    required this.phaseLabel,
    this.phaseAccent = AppColors.red,
    this.maxMbps = 200,
  });

  final double? valueMbps;
  final double progress;
  final bool isRunning;
  final String phaseLabel;
  final Color phaseAccent;
  final double maxMbps;

  @override
  State<SpeedGauge> createState() => _SpeedGaugeState();
}

class _SpeedGaugeState extends State<SpeedGauge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isRunning) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SpeedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.animateTo(0);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;

    String display;
    String unit;
    if (widget.valueMbps == null) {
      display = '—';
      unit = 'Mbps';
    } else if (widget.valueMbps! >= 1000) {
      display = (widget.valueMbps! / 1000).toStringAsFixed(2);
      unit = 'Gbps';
    } else if (widget.valueMbps! < 1.0) {
      display = (widget.valueMbps! * 1024).toStringAsFixed(0);
      unit = 'Kbps';
    } else {
      display = _formatSpeed(widget.valueMbps!);
      unit = 'Mbps';
    }

    return Semantics(
      label: 'Speed gauge: $display $unit, ${widget.phaseLabel}',
      liveRegion: widget.isRunning,
      child: RepaintBoundary(
        child: SizedBox(
          width: 300,
          height: 300,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: widget.progress.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, animatedProgress, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Background Glow
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      final pulse = _pulseController.value;
                      return Container(
                        width: widget.isRunning ? 180 + (20 * pulse) : 180,
                        height: widget.isRunning ? 180 + (20 * pulse) : 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.phaseAccent.withValues(alpha: widget.isRunning ? 0.1 + (0.1 * pulse) : 0.05),
                              blurRadius: widget.isRunning ? 40 + (30 * pulse) : 20,
                              spreadRadius: widget.isRunning ? 5 + (10 * pulse) : 0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  CustomPaint(
                    size: const Size(300, 300),
                    painter: _GaugePainter(
                      progress: animatedProgress,
                      isRunning: widget.isRunning,
                      accent: widget.phaseAccent,
                      surface: colors.surface,
                      text: colors.text,
                      card: colors.card,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        display,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2,
                              height: 1,
                              color: colors.text,
                              fontFamily: 'JetBrainsMono',
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        unit.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colors.muted,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                      ),
                      const SizedBox(height: 32),
                      AnimatedScale(
                        scale: widget.isRunning ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: widget.phaseAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: widget.phaseAccent.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            widget.phaseLabel.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: widget.phaseAccent,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static String _formatSpeed(double mbps) {
    if (mbps >= 100) return mbps.toStringAsFixed(0);
    if (mbps >= 10) return mbps.toStringAsFixed(1);
    return mbps.toStringAsFixed(2);
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.isRunning,
    required this.accent,
    required this.surface,
    required this.text,
    required this.card,
  });

  final double progress;
  final bool isRunning;
  final Color accent;
  final Color surface;
  final Color text;
  final Color card;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    const startAngle = math.pi * 0.78;
    const sweepAngle = math.pi * 1.44;

    // Outer ring
    final trackPaint = Paint()
      ..color = text.withValues(alpha: isRunning ? 0.12 : 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Dotted track with depth
    for (var i = 0; i <= 60; i++) {
      final angle = startAngle + (sweepAngle * (i / 60));
      final isMajor = i % 10 == 0;
      final length = isMajor ? 12.0 : 6.0;
      
      final p1 = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + (radius - 15 - length) * math.cos(angle),
        center.dy + (radius - 15 - length) * math.sin(angle),
      );
      
      final dotPaint = Paint()
        ..color = text.withValues(alpha: isMajor ? 0.5 : 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isMajor ? 2.5 : 1.5;

      canvas.drawLine(p1, p2, dotPaint);
    }

    final arcSweep = sweepAngle * progress;
    if (arcSweep > 0.001) {
      final progressPaint = Paint()
        ..shader = SweepGradient(
          colors: [accent.withValues(alpha: 0.1), accent, accent],
          stops: const [0.0, 0.8, 1.0],
          transform: GradientRotation(startAngle),
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcSweep,
        false,
        progressPaint,
      );

      // Value pointer
      final pointerAngle = startAngle + arcSweep;
      final pointerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2); // Simple glow instead of setShadowLayer

      canvas.drawCircle(
        Offset(
          center.dx + radius * math.cos(pointerAngle),
          center.dy + radius * math.sin(pointerAngle),
        ),
        6,
        pointerPaint,
      );

      if (isRunning) {
        final glow = Paint()
          ..color = accent.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 28
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          arcSweep,
          false,
          glow,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => true;
}
