import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final Function()? onTap;
  final bool enabled;
  final String text;
  final Color? color;
  final bool autoSizeText;
  final TextStyle? style;

  const GenericButton({
    Key? key,
    this.onTap,
    required this.text,
    this.color,
    this.style,
    this.enabled = true,
    this.autoSizeText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline3?.copyWith(
            color: enabled ? color ?? Colors.green : Colors.grey,
          ),
    );
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? color ?? Colors.green : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: textWidget,
      ),
    );
  }
}
