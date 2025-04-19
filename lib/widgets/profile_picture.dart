import 'package:cached_network_image/cached_network_image.dart';
import 'package:kingz_cut_mobile/widgets/card_shimmer.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.imageUrl, this.size});
  final String? imageUrl;
  final double? size;

  //  "https://www.istockphoto.com/resources/images/PhotoFTLP/P1-AUGUST-iStock-1319659043.jpg"
  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Image.asset(
          'assets/images/aw-20.png',
          height: size,
          width: size,
          frameBuilder: (
            BuildContext context,
            Widget child,
            int? frame,
            bool? wasSynchronouslyLoaded,
          ) {
            return Container(
              width: size,
              decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: child,
            );
          },
        )
        : CachedNetworkImage(
          height: size,
          width: size,
          imageUrl:
              imageUrl!, //  'https://www.istockphoto.com/resources/images/PhotoFTLP/P1-AUGUST-iStock-1319659043.jpg',
          imageBuilder:
              (context, imageProvider) => Container(
                decoration: ShapeDecoration(
                  // color: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: .5,
                    ),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          progressIndicatorBuilder:
              (context, url, downloadProgress) =>
                  CardShimmer(height: size!, width: size!, borderRadius: 50),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
  }
}
