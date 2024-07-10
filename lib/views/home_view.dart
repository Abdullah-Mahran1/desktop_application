import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/ch_selector_cubit.dart';
import 'package:desktop_application/cubits/cubit/side_buttons_cubit.dart';
import 'package:desktop_application/data_handling/graph_data_processing.dart';
import 'package:desktop_application/data_handling/server_communication.dart';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/widgets/ch_selector_text_button.dart';
import 'package:desktop_application/widgets/line_chart.dart';
import 'package:desktop_application/widgets/navigator_text_button.dart';
import 'package:desktop_application/widgets/side_menu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  Future<List<FlSpot>> loadData() async {
    // You can call your async functions here
    // await func1();
    readFromDeviceLoop();
    return await loadGraphData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => SideButtonsCubit(),
      child: BlocBuilder<SideButtonsCubit, SideButtonsState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(secoundBackgroundColor),
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: SideMenu()),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding),
                        const Text('Wise 750 Dashboard',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: defaultPadding),
                        const ChSelectorPanel(),
                        const SizedBox(height: defaultPadding),
                        FutureBuilder<List<FlSpot>>(
                          future: loadData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return MyLineChart(data: snapshot.data!);
                            }
                          },
                        ),
                      ]),
                ),
              ),
              const Expanded(flex: 2, child: Column())
            ],
          );
        },
      ),
    ));
  }
}

class ChSelectorPanel extends StatelessWidget {
  const ChSelectorPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(secoundBackgroundColor),
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8)),
        child: BlocProvider<ChSelectorCubit>(
          create: (context) => ChSelectorCubit(),
          child: BlocBuilder<ChSelectorCubit, ChSelectorState>(
            builder: (context, state) {
              return Row(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Text('Which Channels to monitor?',
                      style: TextStyle(color: Color(blackColor))),
                ),
                ChSelectorTextButton(
                    color: const Color(ch0Color),
                    index: 0,
                    isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                        .selectedChannels[0])),
                ChSelectorTextButton(
                    color: const Color(ch1Color),
                    index: 1,
                    isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                        .selectedChannels[1])),
                ChSelectorTextButton(
                  color: const Color(ch2Color),
                  index: 2,
                  isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                      .selectedChannels[2]),
                ),
                ChSelectorTextButton(
                  color: const Color(ch3Color),
                  index: 3,
                  isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                      .selectedChannels[3]),
                )
              ]);
            },
          ),
        ));
  }
}
