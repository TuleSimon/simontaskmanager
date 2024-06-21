import 'package:flutter/material.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/app_colors.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/body_text.dart';

class TodoPasswordTextField extends StatefulWidget {
  final String? title;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? hideBorder;
  final TextInputAction? keyboardAction;

  const TodoPasswordTextField(
      {super.key,
      this.title,
      required this.controller,
      this.hint,
      this.keyboardType,
      this.keyboardAction,
      this.style,
      this.hintStyle,
      this.hideBorder});

  @override
  State<TodoPasswordTextField> createState() => _TodoextFieldState();
}

class _TodoextFieldState extends State<TodoPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          BodyText(
            text: widget.title!,
            textColor: AppColors.gray_700,
            fontSize: 14,
          ),
          SizedBox(height: 6)
        ],
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          obscuringCharacter: "*",
          style: widget.style ??
              Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.gray_300, fontSize: 12),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.gray_300, fontSize: 12),
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
            suffixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: _obscureText
                      ? const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 20,
                        )
                      : const Icon(
                          Icons.password,
                          size: 20,
                        )),
            ),
          ),
        )
      ],
    );
  }
}
