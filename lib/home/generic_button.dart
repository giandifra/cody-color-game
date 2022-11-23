import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final Function()? onTap;
  final bool enabled;
  final String text;
  final Color? color;

  const GenericButton({
    Key? key,
    this.onTap,
    required this.text,
    this.color,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3?.copyWith(
                color: enabled ? color ?? Colors.green : Colors.grey,
              ),
        ),
      ),
    );
  }
}
