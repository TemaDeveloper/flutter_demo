import 'package:flutter/material.dart';

import 'item.dart';


// TODO: find a way to make constructor const
class BottomNavBar extends StatelessWidget {
  /// A bottom bar that faithfully follows the design by Aurélien Salomon
  ///
  /// https://dribbble.com/shots/5925052-Google-Bottom-Bar-Navigation-Pattern/
  BottomNavBar({
    super.key,
    required List<BottomNavBarItem> items,
    required this.onTap,
    this.backgroundColor,
    this.currentIndex = 0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.itemShape = const StadiumBorder(),
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
  }) : items = items.map((i) => NavBarItem(
    title: i.title,
    icon: i.icon,
    activeIcon: i.activeIcon ?? i.icon,
    selectedColor: i.selectedColor ?? selectedItemColor,
    unselectedColor: i.unselectedColor ?? unselectedItemColor,
    itemShape: itemShape,
    margin: margin,
    itemPadding: itemPadding,
    selectedColorOpacity: selectedColorOpacity ?? 0.1,
    duration: duration,
    curve: curve,
    onTap: () => onTap(items.indexOf(i)),
  )).toList();

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  late List<NavBarItem> items;

  final int currentIndex;
  final Function(int) onTap;
  
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;
  final EdgeInsets margin;
  final ShapeBorder itemShape;
  final Color?  backgroundColor;
  final Color?  selectedItemColor;
  final Color?  unselectedItemColor;
  final double? selectedColorOpacity;



  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: SafeArea(
        minimum: margin,
        child: Row(
          /// Using a different alignment when there are 2 items or less
          /// so it behaves the same as BottomNavigationBar.
          mainAxisAlignment: items.length <= 2
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.spaceBetween,
          children: [
            for (final item in items)
              item(context, items.indexOf(item) == currentIndex),
          ],
        ),
      ),
    );
  }
}

/// A sort of config for NavBarItem, for default values see: [BottomNavBar::constructor]
class BottomNavBarItem {
  final Widget icon;
  final Widget? activeIcon;
  final Widget title;
  final Color? selectedColor;
  final Color? unselectedColor;

  BottomNavBarItem({
    required this.icon,
    required this.title,
    this.selectedColor,
    this.unselectedColor,
    this.activeIcon,
  });
}
