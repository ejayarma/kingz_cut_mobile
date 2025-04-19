import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlippingCard extends StatefulWidget {
  final double size;
  final Duration flipDuration;

  const FlippingCard({
    super.key,
    this.size = 50,
    this.flipDuration = const Duration(seconds: 2),
  });

  @override
  State<FlippingCard> createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.flipDuration,
    )..repeat(); // Makes the animation repeat indefinitely

    _animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi, // Full 360-degree rotation
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Adds perspective
            ..rotateY(_animation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2C56), // Navy blue
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
