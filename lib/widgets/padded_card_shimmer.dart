import 'package:flutter/material.dart';

import 'card_shimmer.dart';

class PaddedCardShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const PaddedCardShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CardShimmer(
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }
}
