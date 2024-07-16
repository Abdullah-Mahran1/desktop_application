import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/ch_selector_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChSelectorTextButton extends StatelessWidget {
  const ChSelectorTextButton(
      {super.key,
      required this.color,
      required this.index,
      required this.isSelected});
  final Color color;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            overlayColor: const Color(highlightColor),
            foregroundColor: const Color(blackColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: () {
          BlocProvider.of<ChSelectorCubit>(context).selectedChannels[index] =
              !BlocProvider.of<ChSelectorCubit>(context)
                  .selectedChannels[index];
          BlocProvider.of<ChSelectorCubit>(context).updateChannels();
          debugPrint(
              'Selected channels are now ${BlocProvider.of<ChSelectorCubit>(context).selectedChannels}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Row(children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? color : const Color(secondaryColor),
                size: 20,
              ),
              Text(
                ' Ch$index',
                style: const TextStyle(fontSize: 16, color: Color(blackColor)),
              )
            ]),
          ),
        ));
  }
}
