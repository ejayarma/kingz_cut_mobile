import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const CardShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        baseColor: Theme.of(context).colorScheme.primary.withOpacity(.3),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(.1),
        child: Card(
          // clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          // child: SizedBox(height: height, width: width),
        ),
      ),
    );
  }
}
