import 'package:desktop_application/const/constants.dart';
import 'package:flutter/material.dart';

class ChSelectorTextButton extends StatelessWidget {
  const ChSelectorTextButton(
      {super.key,
      required this.color,
      required this.title,
      required this.isSelected,
      required this.onPressed});
  final Color color;
  final String title;
  final bool isSelected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          overlayColor: const Color(highlightColor),
          foregroundColor: const Color(blackColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Row(children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? color : const Color(secoundaryColor),
                size: 20,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Color(blackColor)),
              )
            ]),
          ),
        ));
  }
}
