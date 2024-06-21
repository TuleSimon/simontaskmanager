import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simontaskmanager/features/taskmanager/utils/extensions/ExtensionsFunc.dart';

import 'package:simontaskmanager/features/taskmanager/presentation/widgets/app_colors.dart';

class BodyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign align;

  final TextDecoration? decoration;
  final int? maxLines;
  final TextStyle? style;

  const BodyText({
    super.key,
    required this.text,
    this.fontSize,
    this.style,
    this.fontWeight = FontWeight.normal,
    this.textColor = AppColors.black,
    this.align = TextAlign.center,
    this.maxLines,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.clip,
      style: (style ?? context.getTextTheme().bodyMedium)?.copyWith(
        fontFamilyFallback: ["Roboto"],
        fontFamily: "Poppins",
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: AppColors.secondary,
        color: textColor,
      ),
    );
  }
}

class BodyTextWithIcon extends StatelessWidget {
  final String text;
  final double fontSize;
  final double? iconSize;
  final FontWeight fontWeight;
  final Color textColor;
  final bool isExpanded;
  final IconData? assets;
  final IconData? assets2;
  final Color? tint;
  final TextAlign align;
  final int? maxLines;
  final double? spacing;
  final TextStyle? style;

  const BodyTextWithIcon({
    super.key,
    required this.text,
    this.fontSize = 16.0,
    this.iconSize = 16.0,
    this.style,
    this.isExpanded = false,
    this.fontWeight = FontWeight.normal,
    this.textColor = AppColors.black,
    this.align = TextAlign.center,
    this.maxLines,
    this.assets,
    this.tint,
    this.spacing,
    this.assets2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (assets != null) ...[
          Icon(
            assets!,
            size: iconSize,
            color: tint,
          ),
          SizedBox(
            width: spacing ?? 4,
          ),
        ],
        isExpanded
            ? Expanded(
                child: Text(
                  text,
                  softWrap: true,
                  textAlign: align,
                  maxLines: maxLines,
                  overflow: TextOverflow.clip,
                  style: (style ?? context.getTextTheme().bodyMedium)?.copyWith(
                    fontSize: fontSize,
                    fontFamilyFallback: ["Roboto"],
                    fontFamily: "Poppins",
                    fontWeight: fontWeight,
                    color: textColor,
                  ),
                ),
              )
            : Text(
                text,
                softWrap: true,
                textAlign: align,
                maxLines: maxLines,
                overflow: TextOverflow.clip,
                style: (style ?? context.getTextTheme().bodyMedium)?.copyWith(
                  fontSize: fontSize,
                  fontFamilyFallback: ["Roboto"],
                  fontFamily: "Poppins",
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
        if (assets2 != null) ...[
          SizedBox(
            width: spacing ?? 4,
          ),
          Icon(
            assets2!,
            size: iconSize,
            color: tint,
          ),
          SizedBox(
            width: spacing ?? 4,
          ),
        ],
      ],
    );
  }
}

const HORIZONTAL_PADDING = 15.0;