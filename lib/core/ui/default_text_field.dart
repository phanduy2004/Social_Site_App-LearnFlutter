import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? prefixText;
  final String? initialValue; // Lưu ý: nếu có controller, initialValue sẽ bị bỏ qua
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;

  // --- Mới thêm ---
  final Widget? suffixIcon;              // Icon/ button bên phải (vd: IconButton(search))
  final String? suffixText;              // Text bên phải (vd: "VN")
  final TextStyle? suffixStyle;          // Style cho suffixText
  final bool readOnly;                   // Cho phép chỉ đọc (vd: mở date picker)
  final VoidCallback? onTap;             // Xử lý khi tap vào field (khi readOnly)
  final TextInputAction? textInputAction;
  final bool obscureText;                // Password
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const DefaultTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixText,
    this.initialValue,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.maxLength,
    this.maxLines,
    this.minLines,
    // --- Mới thêm ---
    this.suffixIcon,
    this.suffixText,
    this.suffixStyle,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.obscureText = false,
    this.focusNode,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      style: theme.textTheme.bodyMedium,
      onChanged: onChanged,
      initialValue: controller == null ? initialValue : null, // tránh xung đột
      maxLength: maxLength,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.onSurfaceVariant,
        hintText: hintText,
        prefixText: prefixText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
        suffixStyle: suffixStyle ?? theme.textTheme.bodyMedium,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        counterStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
