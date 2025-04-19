import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HeroScreenWrapper extends StatelessWidget {
  const HeroScreenWrapper({
    super.key,
    this.heroImagePath = 'assets/images/mother_baby.png',
    this.backgroundColor,
    this.isNetworkImage = false,
    this.titleColor = Colors.white,
    required this.title,
    required this.content,
    this.titleHasBorder = false,
    this.backBtnHasBorder = false,
  });

  final String heroImagePath;
  final String title;
  final Widget content;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final bool titleHasBorder;
  final bool backBtnHasBorder;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Match the AppBar color
        statusBarIconBrightness: Brightness.light, // Icons color
      ),
    );

    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          // Hero Image Section with Text Overlay
          SizedBox(
            child: Stack(
              children: [
                isNetworkImage
                    ? ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: CachedNetworkImage(
                          imageUrl: heroImagePath,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        heroImagePath,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
              ],
            ),
          ),

          // Content
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: backgroundColor ??
                        Theme.of(context).colorScheme.onPrimaryFixed,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: content,
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: !backBtnHasBorder
                          ? null
                          : Border.all(
                              color:
                                  Theme.of(context).colorScheme.onPrimaryFixed,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Stack(
                      children: [
                        // Stroked text as border.
                        if (titleHasBorder)
                          Text(
                            title,
                            maxLines: 3,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  // fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,

                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = Theme.of(context)
                                        .colorScheme
                                        .onPrimaryFixed,
                                ),
                          ),
                        Text(
                          title,
                          maxLines: 3,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.fade,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: titleColor,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
