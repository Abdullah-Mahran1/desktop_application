import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/device_connection_cubit.dart';
import 'package:desktop_application/cubits/settings_cubit/side_buttons_cubit.dart';
import 'package:desktop_application/views/alerts_section.dart';
import 'package:desktop_application/views/dashboard.dart';
import 'package:desktop_application/views/settings_view.dart';
import 'package:desktop_application/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SideButtonsCubit(),
        ),
        BlocProvider(
          create: (context) => DeviceConnectionCubit(),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<SideButtonsCubit, SideButtonsState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    color: const Color(secondBackgroundColor),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: SideMenu(),
                    ),
                  ),
                ),
                ...context.read<SideButtonsCubit>().isSettings
                    ? [SettingsView()]
                    : [
                        const MyDashboard(),
                        Expanded(
                          flex: 1,
                          child: VerticalDivider(
                            color: const Color(secondaryColor),
                            indent: MediaQuery.of(context).size.height * 0.05,
                            endIndent:
                                MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.height,
                          ),
                        ),
                        AlertsSection(),
                      ],
              ],
            );
          },
        ),
      ),
    );
  }
}
