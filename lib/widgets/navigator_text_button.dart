import 'package:desktop_application/const/constants.dart';
import 'package:flutter/material.dart';

class NavigatorTextButton extends StatelessWidget {
  const NavigatorTextButton(
      {super.key,
      required this.myString,
      required this.icon,
      required this.isSelected,
      required this.onPressed});
  final String myString;
  final IconData icon;
  final bool isSelected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: TextButton(
          style: TextButton.styleFrom(
            overlayColor: const Color(highlightColor),
            foregroundColor: isSelected
                ? const Color(highlightColor)
                : const Color(secoundaryColor),
            shadowColor: isSelected
                ? const Color(highlightColor).withOpacity(0.2)
                : Colors.transparent,
            elevation: isSelected ? 1.0 : 0.0, // Set the elevation,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    icon,
                    size: 20,
                  ),
                ),
                Text(
                  myString,
                  style: const TextStyle(fontSize: 16),
                )
              ]),
            ),
          )),
    );
  }
}
