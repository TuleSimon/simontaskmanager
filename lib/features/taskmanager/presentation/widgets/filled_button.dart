import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/app_colors.dart';
import 'package:simontaskmanager/features/taskmanager/utils/extensions/ExtensionsFunc.dart';

import 'body_text.dart';

class FilledButtonWithIcon extends StatelessWidget {
  final String text;
  final double? fontSize;
  final bool loading;
  final FontWeight fontWeight;
  final Color textColor;
  final Color? bgColor;

  final bool enabled;
  final TextAlign align;
  final EdgeInsets? padding;

  final IconData? icon;
  final IconData? startIcon;
  final IconData? startIcon2;
  final bool expand;

  final double radius;
  final void Function()? onPressed;

  const FilledButtonWithIcon({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.textColor = AppColors.onPrimary,
    this.align = TextAlign.center,
    this.icon,
    this.startIcon,
    this.loading = false,
    this.padding,
    this.onPressed,
    this.enabled = true,
    this.radius = 8,
    this.startIcon2,
    this.expand = false,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: (enabled && !loading)
                ? bgColor ?? AppColors.primary
                : (bgColor ?? AppColors.primary).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: padding ??
                const EdgeInsets.symmetric(
                    vertical: 15, horizontal: HORIZONTAL_PADDING)),
        onPressed: () {
          if (enabled && !loading) {
            onPressed?.call();
          }
        },
        child: Flex(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.horizontal,
            children: [
              if (loading) ...[
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              ] else ...[
                if (startIcon != null) ...[
                  Icon(
                    startIcon,
                    color: AppColors.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
                if (startIcon2 != null) ...[
                  Icon(
                    startIcon2!,
                    color: AppColors.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
                Flexible(
                  flex: expand ? 1 : 0,
                  child: Text(
                    text,
                    textAlign: align,
                    softWrap: true,
                    textWidthBasis: TextWidthBasis.parent,
                    maxLines: 2,
                    style: context.getTextTheme().bodyMedium?.copyWith(
                          fontSize: fontSize ?? 15,
                          fontWeight: fontWeight,
                          height: 1.3,
                          fontFamilyFallback: ["Roboto"],
                          fontFamily: "Poppins",
                          color: textColor,
                        ),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    icon,
                    color: AppColors.onPrimary,
                  )
                ]
              ]
            ]));
  }
}
