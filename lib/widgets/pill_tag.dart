import 'package:kingz_cut_mobile/enums/pill_tag_shape.dart';
import 'package:flutter/material.dart';

class PillTag extends StatelessWidget {
  final String label;
  final Color? bgColor;
  final Color? textColor;
  final EdgeInsets padding;
  final PillTagShape shape;

  const PillTag({
    super.key,
    required this.label,
    this.bgColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
    this.shape = PillTagShape.stadium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        shape:
            shape == PillTagShape.stadium
                ? StadiumBorder(
                  side: BorderSide(
                    color: bgColor ?? Theme.of(context).colorScheme.primary,
                  ),
                )
                : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: bgColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
        color:
            bgColor?.withOpacity(.3) ??
            Theme.of(context).colorScheme.inversePrimary.withOpacity(.5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: textColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
