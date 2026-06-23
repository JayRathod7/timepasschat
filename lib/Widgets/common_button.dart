// lib/Widgets/app_button.dart
import 'package:flutter/material.dart';

import '../Constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? loadingWidget;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 56,
    this.borderRadius = 18,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.loadingWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? (loadingWidget ??
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  ))
            : Text(
                text,
                style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
              ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final String? imageAsset;
  final double imageSize;
  final Widget? leading;
  final Widget? loadingWidget;
  final EdgeInsetsGeometry? padding;

  const AppOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 56,
    this.borderRadius = 18,
    this.backgroundColor = Colors.white,
    this.foregroundColor = AppColors.textPrimary,
    this.borderColor = AppColors.googleBorder,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w700,
    this.icon,
    this.iconColor,
    this.iconSize = 22,
    this.imageAsset,
    this.imageSize = 22,
    this.leading,
    this.loadingWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    if (leading != null) {
      leadingWidget = leading!;
    } else if (imageAsset != null) {
      leadingWidget = Image.asset(
        imageAsset!,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.contain,
      );
    } else if (icon != null) {
      leadingWidget = Icon(
        icon,
        size: iconSize,
        color: iconColor ?? foregroundColor,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: BorderSide(color: borderColor),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? (loadingWidget ??
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingWidget != null) ...[
                    leadingWidget,
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
