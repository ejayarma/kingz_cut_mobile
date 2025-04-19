import 'dart:ui';

import 'package:kingz_cut_mobile/widgets/fipping_card.dart';
import 'package:flutter/material.dart';
import 'package:uiblock/uiblock.dart';

class CustomUiBlock {
  static void block(
    BuildContext context, {
    String message = 'Loading...\nPlease wait',
    Widget content = const FlippingCard(size: 40),
    double width = 300,
    double height = 200,
    bool hasBorder = true,
  }) {
    UIBlock.block(
      context,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.onPrimaryFixed.withOpacity(0.3),
      imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      childBuilder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(5),
            width: width,
            height: height,
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border:
                        !hasBorder
                            ? null
                            : Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(.5),
                              width: 5,
                            ),
                  ),
                  child: content,
                ),
                const SizedBox(height: 20.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void unblock(BuildContext context) {
    UIBlock.unblock(context);
  }
}
