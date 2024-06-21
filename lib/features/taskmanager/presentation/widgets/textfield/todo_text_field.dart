import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/app_colors.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/body_text.dart';

class TodoTextField extends StatefulWidget {
  final String? title;
  final String? toolTip;
  final String? hint;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  final TextStyle? style;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final bool readOnly;
  final String? error;

  final List<TextInputFormatter>? formatters;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Function(String, String?, String?)? onChange2;
  final TextAlign? titleAlign;
  final TextStyle? titleStyle;
  final bool? hideBorder;
  final bool? isGooglePlace;
  final TextInputAction? keyboardAction;

  const TodoTextField(
      {super.key,
      this.title,
      this.controller,
      this.hint,
      this.keyboardType,
      this.keyboardAction,
      this.style,
      this.suffixIcon,
      this.hintStyle,
      this.formatters,
      this.readOnly = false,
      this.onTap,
      this.onChange,
      this.onChange2,
      this.titleAlign,
      this.isGooglePlace,
      this.titleStyle,
      this.toolTip,
      this.error,
      this.hideBorder,
      this.maxLength});

  @override
  State<TodoTextField> createState() => _TodoTextFieldState();
}

class _TodoTextFieldState extends State<TodoTextField> {
  String inpit = "";
  late FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          FractionallySizedBox(
            widthFactor: 1,
            child: Tooltip(
              triggerMode: widget.toolTip != null
                  ? TooltipTriggerMode.tap
                  : TooltipTriggerMode.manual,
              margin: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
              decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 1),
              message: widget.toolTip != null ? null : "",
              richMessage: widget.toolTip != null
                  ? TextSpan(
                      text: widget.title,
                      style: const TextStyle(
                          color: AppColors.bg,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      children: <InlineSpan>[
                        TextSpan(
                          text: "\n\n" + widget.toolTip!,
                          style: const TextStyle(
                              color: AppColors.bg,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                      ],
                    )
                  : null,
              preferBelow: false,
              child: BodyTextWithIcon(
                text: widget.title!,
                assets2: widget.toolTip != null ? Icons.help : null,
                spacing: 14,
                textColor: AppColors.gray_700,
                style: widget.titleStyle,
                align: widget.titleAlign ?? TextAlign.center,
                fontSize: widget.titleStyle != null ? 12 : 14,
              ),
            ),
          ),
          const SizedBox(height: 6)
        ],
        TextField(
          controller: widget.controller,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: (e) {
            widget.onChange?.call(e);
          },
          keyboardType: widget.formatters
                      ?.contains(FilteringTextInputFormatter.digitsOnly) ==
                  true
              ? const TextInputType.numberWithOptions(
                  signed: true, decimal: true)
              : null,
          maxLength: widget.maxLength,
          inputFormatters: widget.formatters,
          style: widget.style ??
              Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12, color: AppColors.textPrimary),
          decoration: InputDecoration(
            error: widget.error != null
                ? BodyText(
                    text: widget.error!,
                    textColor: AppColors.red_600,
                    fontSize: 12,
                  )
                : null,
            errorBorder: OutlineInputBorder(
              borderRadius: widget.hideBorder == true
                  ? BorderRadius.zero
                  : BorderRadius.circular(8),
              borderSide: widget.hideBorder == true
                  ? const BorderSide(color: Colors.transparent, width: 0)
                  : const BorderSide(width: 1, color: AppColors.red),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.gray_300, fontSize: 12),
            suffixIcon: widget.suffixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.hideBorder == true
                  ? BorderRadius.zero
                  : BorderRadius.circular(8),
              borderSide: widget.hideBorder == true
                  ? const BorderSide(color: Colors.transparent, width: 0)
                  : const BorderSide(width: 1, color: AppColors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.hideBorder == true
                  ? BorderRadius.zero
                  : BorderRadius.circular(8),
              borderSide: widget.hideBorder == true
                  ? const BorderSide(color: Colors.transparent, width: 0)
                  : const BorderSide(width: 1, color: AppColors.gray_100),
            ),
            border: OutlineInputBorder(
              borderRadius: widget.hideBorder == true
                  ? BorderRadius.zero
                  : BorderRadius.circular(8),
              borderSide: widget.hideBorder == true
                  ? const BorderSide(color: Colors.transparent, width: 0)
                  : const BorderSide(width: 1, color: AppColors.gray_100),
            ),
          ),
        )
      ],
    );
  }
}
