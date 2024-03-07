import 'package:flutter/material.dart';

class NavBarItem {
  final Widget title;
  final Widget icon;
  final Widget activeIcon;
  final Color? selectedColor;
  final Color? unselectedColor;

  final ShapeBorder itemShape;
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;

  final double selectedColorOpacity;

  final VoidCallback onTap;

  const NavBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.selectedColor,
    required this.unselectedColor,
    required this.itemShape,
    required this.margin,
    required this.itemPadding,
    required this.duration,
    required this.curve,
    required this.selectedColorOpacity,
    required this.onTap
  });

  Widget call(BuildContext context, bool isSelected) {
    final theme = Theme.of(context);
    final selectedColor   = this.selectedColor   ?? theme.primaryColor;
    final unselectedColor = this.unselectedColor ?? theme.unselectedWidgetColor;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        end: isSelected ? 1.0 : 0.0,
      ),
      curve: curve,
      duration: duration,
      builder: (context, t, _) {
        return Material(
          color: Color.lerp(selectedColor.withOpacity(0.0),
              selectedColor.withOpacity(selectedColorOpacity), t),
          shape: itemShape,
          child: InkWell(
            onTap: onTap,
            customBorder: itemShape,
            focusColor: selectedColor.withOpacity(0.1),
            highlightColor: selectedColor.withOpacity(0.1),
            splashColor: selectedColor.withOpacity(0.1),
            hoverColor: selectedColor.withOpacity(0.1),
            child: Padding(
              padding: itemPadding -
                  (Directionality.of(context) == TextDirection.ltr
                      ? EdgeInsets.only(right: itemPadding.right * t)
                      : EdgeInsets.only(left: itemPadding.left * t)),
              child: Row(
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: Color.lerp(unselectedColor, selectedColor, t),
                      size: 24,
                    ),
                    child: isSelected ? activeIcon : icon,
                  ),
                  ClipRect(
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      child: Align(
                        alignment: const Alignment(-0.2, 0.0),
                        widthFactor: t,
                        child: Padding(
                          padding:
                              Directionality.of(context) == TextDirection.ltr
                                  ? EdgeInsets.only(
                                      left: itemPadding.left / 2,
                                      right: itemPadding.right)
                                  : EdgeInsets.only(
                                      left: itemPadding.left,
                                      right: itemPadding.right / 2),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Color.lerp(selectedColor.withOpacity(0.0),
                                  selectedColor, t),
                              fontWeight: FontWeight.w600,
                            ),
                            child: title,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
