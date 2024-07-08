import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/widgets/ch_selector_text_button.dart';
import 'package:desktop_application/widgets/navigator_text_button.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: const Color(secoundBackgroundColor),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: SideMenu()),
          ),
        ),
        const Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: defaultPadding),
              Text('Wise 750 Dashboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: defaultPadding),
              ChSelectorPanel()
            ]),
          ),
        ),
        const Expanded(flex: 2, child: Column())
      ],
    ));
  }
}

class ChSelectorPanel extends StatefulWidget {
  const ChSelectorPanel({
    super.key,
  });

  @override
  State<ChSelectorPanel> createState() => _ChSelectorPanelState();
}

class _ChSelectorPanelState extends State<ChSelectorPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(secoundBackgroundColor),
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Text('Which Channels to monitor?',
                style: TextStyle(color: Color(blackColor))),
          ),
          ChSelectorTextButton(
            color: const Color(ch0Color),
            title: ' Ch0',
            isSelected: (selectedChannels[0]),
            onPressed: () {
              setState(() {
                selectedChannels[0] = !selectedChannels[0];
              });
              debugPrint('Selected channels are now $selectedChannels');
            },
          ),
          ChSelectorTextButton(
            color: const Color(ch1Color),
            title: ' Ch1',
            isSelected: (selectedChannels[1]),
            onPressed: () {
              setState(() {
                selectedChannels[1] = !selectedChannels[1];
              });
              debugPrint('Selected channels are now $selectedChannels');
            },
          ),
          ChSelectorTextButton(
            color: const Color(ch2Color),
            title: ' Ch2',
            isSelected: (selectedChannels[2]),
            onPressed: () {
              setState(() {
                selectedChannels[2] = !selectedChannels[2];
              });
              debugPrint('Selected channels are now $selectedChannels');
            },
          ),
          ChSelectorTextButton(
            color: const Color(ch3Color),
            title: ' Ch3',
            isSelected: (selectedChannels[3]),
            onPressed: () {
              setState(() {
                selectedChannels[3] = !selectedChannels[3];
              });
              debugPrint('Selected channels are now $selectedChannels');
            },
          )
        ]));
  }
}

class SideMenu extends StatefulWidget {
  SideMenu({super.key});

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
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
            isSelected: (selectedSideMenuItem == 0),
            onPressed: () {
              setState(() {
                selectedSideMenuItem = 0;
              });
              debugPrint('Selected menu is now $selectedSideMenuItem');
            }),
        NavigatorTextButton(
            myString: 'Settings',
            icon: Icons.settings,
            isSelected: (selectedSideMenuItem == 1),
            onPressed: () {
              setState(() {
                selectedSideMenuItem = 1;
              });
              debugPrint('Selected menu is now $selectedSideMenuItem');
            }),
      ],
    );
  }
}
