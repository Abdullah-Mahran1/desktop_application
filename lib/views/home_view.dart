import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/ch_selector_cubit.dart';
import 'package:desktop_application/cubits/settings_cubit/side_buttons_cubit.dart';
import 'package:desktop_application/data_handling/graph_data_processing.dart';
import 'package:desktop_application/data_handling/server_communication.dart';
import 'package:desktop_application/models/alert_model.dart';
import 'package:desktop_application/widgets/alert_widget.dart';
import 'package:desktop_application/widgets/ch_selector_text_button.dart';
import 'package:desktop_application/widgets/line_chart.dart';
import 'package:desktop_application/widgets/side_menu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class HomeView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<FlSpot>> loadData() async {
      // You can call your async functions here
      // await func1();
      readFromDeviceLoop();
      return await loadGraphData(context: context);
    }

    return Scaffold(
        body: BlocProvider(
      create: (context) => SideButtonsCubit(),
      child: BlocBuilder<SideButtonsCubit, SideButtonsState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  color: const Color(secoundBackgroundColor),
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: SideMenu()),
                ),
              ),
              Expanded(
                flex: 30,
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
              Expanded(
                flex: 1,
                child: VerticalDivider(
                    color: Color(secoundaryColor),
                    indent: MediaQuery.of(context).size.height * 0.05,
                    endIndent: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.height),
              ),
              Expanded(
                flex: 20,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: defaultPadding),
                      const Text('Recent Alerts',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: defaultPadding),
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<AlertModel>('alertsWiseDashboard')
                                .listenable(),
                        builder: (context, Box<AlertModel> box, _) {
                          var alerts = box.values.toList();
                          return SizedBox(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Scrollbar(
                              thickness: 6,
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                reverse: true,
                                itemCount: alerts.length,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  return AlertWidget(alert: alerts[index]);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2, vertical: 2),
                  child: Text('Which Channels to monitor?',
                      style: TextStyle(color: Color(blackColor))),
                ),
                const Spacer(),
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
                ),
                SizedBox(
                  width: defaultPadding / 2,
                )
              ]);
            },
          ),
        ));
  }
}
