import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton(
      {required this.child,
        this.onTap,
        this.padding,
        this.borderColor,
        this.borderWidth,
        this.color,
        this.leading,
        this.trailing,
        this.shrinkWrap = false,
        this.shadow = true,
        this.shadowColor,
        this.bottomPadding = 8.0,
        this.borderRadius = 5.0,
        this.height,
        Key? key})
      : super(key: key);

  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onTap;
  final EdgeInsets? padding;
  final Color? borderColor;
  final double? borderWidth;
  final Color? color;
  final bool shrinkWrap;
  final bool shadow;
  final Color? shadowColor;
  final double bottomPadding;
  final double borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        height: height,
        decoration: _decoration(context),
        child: Card(
          color: color,
          shadowColor: Theme.of(context).shadowColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 1.0,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    double vert = height != null ? 0.0 : 10.0;
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Padding(
        padding: padding ??
            EdgeInsets.fromLTRB(leading != null ? 16 : 26.0, vert, 20.0, vert),
        child: shrinkWrap
            ? child
            : Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (leading != null) leading!,
            Expanded(child: child),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }

  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        if (shadow)
          BoxShadow(
            color: shadowColor ?? Theme.of(context).colorScheme.shadow,
            offset: const Offset(0.0, 3.0),
            blurRadius: 6.0,
            // spreadRadius: 0.0,
          ),
      ],
    );
  }
}