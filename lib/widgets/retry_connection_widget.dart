// File: lib/widgets/retry_connection_button.dart

import 'package:desktop_application/const/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_application/cubits/device_connection_cubit.dart';

class RetryConnectionButton extends StatelessWidget {
  final void Function()? onPressed;
  const RetryConnectionButton(this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceConnectionCubit, DeviceState>(
      builder: (context, state) {
        // bool isEnabled = state is! TryingToConnect;
        final Color textColor = _getTextColor(state);

        return TextButton(
          style: TextButton.styleFrom(
            overlayColor: const Color(highlightColor),
            elevation: 1.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            // Set the background color to a light gray when disabled
            backgroundColor:
                (state is TryingToConnect) ? Colors.grey[200] : null,
          ),
          onPressed: (state is! TryingToConnect) ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      _getIcon(state),
                      size: 20,
                      color: textColor,
                    ),
                  ),
                  Text(
                    _getText(state),
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIcon(DeviceState state) {
    if (state is Connected) return Icons.check;
    if (state is TryingToConnect) return Icons.hourglass_empty;
    return Icons.loop_outlined;
  }

  String _getText(DeviceState state) {
    if (state is Connected) return 'Connected';
    if (state is TryingToConnect) return 'Connecting...';
    return 'Try 2 Connect';
  }

  Color _getTextColor(DeviceState state) {
    if (state is Connected) return Colors.green;
    if (state is TryingToConnect) return Colors.grey;
    return Colors.red; // or any default color for the enabled state
  }
}
