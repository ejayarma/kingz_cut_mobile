import 'package:kingz_cut_mobile/models/cart_item.dart';
import 'package:kingz_cut_mobile/screens/dashboard/cart_list_screen.dart';
import 'package:kingz_cut_mobile/state_providers/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class DefaultScreenWrapper extends StatefulWidget {
  const DefaultScreenWrapper({
    super.key,
    required this.title,
    required this.content,
    this.appBarColor,
    this.showAction = true,
    this.showBackButton = true,
  });

  final Widget content;
  final String title;
  final bool showAction;
  final bool showBackButton;
  final Color? appBarColor;

  @override
  State<DefaultScreenWrapper> createState() => _DefaultScreenWrapperState();
}

class _DefaultScreenWrapperState extends State<DefaultScreenWrapper> {
  List<CartItem> get cartItems {
    return Provider.of<CartProvider>(context).cartItems;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            widget.appBarColor ??
            Theme.of(
              context,
            ).colorScheme.onPrimaryFixed, // Match the AppBar color
        statusBarIconBrightness: Brightness.light, // Icons color
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            widget.appBarColor ?? Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading:
            !widget.showBackButton
                ? null
                : IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: CircleBorder(eccentricity: .1),
                  ),
                  icon: Icon(
                    CupertinoIcons.chevron_back,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
        actions:
            !widget.showAction
                ? null
                : [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartListScreen(),
                          ),
                        );
                      },
                      icon: badges.Badge(
                        showBadge: cartItems.isNotEmpty,
                        badgeContent: Text(
                          "${cartItems.length}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Theme.of(context).colorScheme.tertiary,
                          padding: EdgeInsets.all(6),
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: widget.content,
    );
  }
}
