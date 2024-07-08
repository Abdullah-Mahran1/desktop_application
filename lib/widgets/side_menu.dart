import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/cubit/side_buttons_cubit.dart';
import 'package:desktop_application/widgets/navigator_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideButtonsCubit, SideButtonsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultPadding),
            const Text(
              'MENU',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            NavigatorTextButton(
                myString: 'Dashboard',
                icon: Icons.maps_home_work_rounded,
                isSelected: (state is SideButtonDashboard),
                onPressed: () {
                  BlocProvider.of<SideButtonsCubit>(context)
                      .navigate(toSettings: false);
                  debugPrint(
                      'Selected menu is now Dashboard, state: ${state is SideButtonSetings}');
                }),
            NavigatorTextButton(
                myString: 'Settings',
                icon: Icons.settings,
                isSelected: (state is SideButtonSetings),
                onPressed: () {
                  BlocProvider.of<SideButtonsCubit>(context)
                      .navigate(toSettings: true);
                  debugPrint(
                      'Selected menu is now Settings. state: ${state is SideButtonSetings}');
                }),
          ],
        );
      },
    );
  }
}
