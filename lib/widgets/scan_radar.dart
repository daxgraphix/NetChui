import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:net_chui/theme/app_theme.dart';

class ScanRadar extends StatefulWidget {
  final bool isScanning;
  final Widget centerIcon;

  const ScanRadar({
    super.key,
    required this.isScanning,
    required this.centerIcon,
  });

  @override
  State<ScanRadar> createState() => _ScanRadarState();
}

class _ScanRadarState extends State<ScanRadar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isScanning) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ScanRadar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning != oldWidget.isScanning) {
      if (widget.isScanning) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient glow
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.netChui.accent.withValues(alpha: widget.isScanning ? 0.08 : 0.03),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          
          // Dotted circles (static)
          ...List.generate(3, (index) {
            final radius = 70.0 + (index * 45.0);
            return Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.netChui.text.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
            );
          }),

          // Pulse animations
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (!widget.isScanning && _controller.value == 0) return const SizedBox.shrink();
                
                final progress = (_controller.value + (index / 3)) % 1.0;
                final opacity = (1 - progress).clamp(0.0, 1.0);
                
                return Container(
                  width: 140 + (160 * progress),
                  height: 140 + (160 * progress),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.netChui.accent.withValues(alpha: opacity * 0.2),
                      width: 1.5,
                    ),
                  ),
                );
              },
            );
          }),

          // The rotating sweep
          if (widget.isScanning)
            RotationTransition(
              turns: _controller,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      context.netChui.accent.withValues(alpha: 0.02),
                      context.netChui.accent.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.5, 0.6],
                  ),
                ),
              ),
            ),

          // Center core
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: context.netChui.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: context.netChui.accent.withValues(alpha: 0.1),
                  blurRadius: 10,
                ),
              ],
              border: Border.all(
                color: context.netChui.border,
                width: 1,
              ),
            ),
            child: Center(
              child: widget.centerIcon,
            ),
          ),
          
          // Little scanning dots
          if (widget.isScanning)
             ...List.generate(4, (index) {
                final angle = (index * 90.0) * (math.pi / 180.0);
                return _ScanningDot(
                  angle: angle,
                  controller: _controller,
                  delay: index * 0.25,
                );
             }),
        ],
      ),
    );
  }
}

class _ScanningDot extends StatelessWidget {
  final double angle;
  final AnimationController controller;
  final double delay;

  const _ScanningDot({
    required this.angle,
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value + delay) % 1.0;
        if (progress > 0.5) return const SizedBox.shrink();
        
        final opacity = (1 - (progress * 2)).clamp(0.0, 1.0);
        final radius = 60 + (80 * progress);
        
        return Transform.translate(
          offset: Offset(
            radius * math.cos(angle + (controller.value * math.pi * 2)),
            radius * math.sin(angle + (controller.value * math.pi * 2)),
          ),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: context.netChui.accent.withValues(alpha: opacity),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
