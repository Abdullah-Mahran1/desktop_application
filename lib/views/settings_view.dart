import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/const/data_singleton.dart';
import 'package:desktop_application/cubits/ch_selector_cubit.dart';
import 'package:desktop_application/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SharedPreferences settings;
  bool isSettingsLoaded = false;

  String? graphTimeScale;
  String? startingDateTime;
  bool isLiveGraph = false;

  Map<String, double> chAlerts = DataSingleton().chAlerts;
  final snackBar = SnackBar(
      content: const Text('Settings saved'),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
      margin: const EdgeInsets.only(
        bottom: 24.0,
        left: 24.0,
        right: 24.0,
      ));

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    settings = await SharedPreferences.getInstance();
    setState(() {
      isSettingsLoaded = true;
      graphTimeScale = settings.getString('xView');
      startingDateTime = settings.getString('startingDateTime');
      isLiveGraph = settings.getBool('isLiveGraph') ?? false;
      for (String key in chAlerts.keys) {
        chAlerts[key] = settings.getDouble(key) ?? 1.0;
      }
    });
  }

  void _toggleLiveGraph(bool value) {
    setState(() {
      isLiveGraph = value;
      if (!isLiveGraph) {
        graphTimeScale = null;
        startingDateTime = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 51,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSettingsLoaded)
              const Center(
                child: Text('Loading settings...'),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildGraphSettings()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildChannelThresholds()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Graph Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Live Graph'),
              value: isLiveGraph,
              onChanged: _toggleLiveGraph,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Graph Time Scale',
                border: OutlineInputBorder(),
              ),
              value: graphTimeScale,
              onChanged: isLiveGraph
                  ? null
                  : (String? newValue) {
                      setState(() {
                        graphTimeScale = newValue!;
                      });
                    },
              items: GraphXView.values.map((view) {
                return DropdownMenuItem<String>(
                  value: view.name,
                  child: Text(view.name),
                );
              }).toList(),
            ),
            const SizedBox(height: defaultPadding),
            const Text('Power range'),
            const SizedBox(height: defaultPadding),
            DateTimePickerWidget(
              isLiveGraph: isLiveGraph,
              initialDateTime: startingDateTime != null
                  ? DateTime.parse(startingDateTime!)
                  : null,
              onDateTimeSelected: isLiveGraph
                  ? (_) {}
                  : (dateTime) {
                      setState(() {
                        startingDateTime = dateTime.toString();
                      });
                    },
            ),
            const SizedBox(height: defaultPadding),
            const Text('How much power should the graph show?',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelThresholds() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Channels Threshold',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...chAlerts.entries.map(
                (entry) => _buildChannelThresholdRow(entry.key, entry.value)),
            const SizedBox(height: 8),
            const Text(
                'Define the values that upon exceeding, you will get an alert',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelThresholdRow(String channel, double threshold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(channel, softWrap: true)),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: threshold.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffix: Text('V'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  chAlerts[channel] = double.tryParse(value) ?? threshold;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ElevatedButton(
        onPressed: _saveSettings,
        child: const Text('Save Settings',
            style: TextStyle(color: Color(highlightColor))),
      ),
    );
  }

  Future<void> _saveSettings() async {
    SharedPreferences settings = await SharedPreferences.getInstance();

    settings.setBool('isLiveGraph', isLiveGraph);
    if (!isLiveGraph) {
      debugPrint('Graph Time Scale: $graphTimeScale');
      if (graphTimeScale != null) {
        settings.setString('xView', graphTimeScale!);
      }
      debugPrint('Starting DateTime: $startingDateTime');
      if (startingDateTime != null) {
        settings.setString('startingDateTime', startingDateTime!);
      } else {
        settings.remove('startingDateTime');
      }
    }
    debugPrint('Channel Thresholds: $chAlerts');
    for (String key in chAlerts.keys) {
      settings.setDouble(key, chAlerts[key] ?? 1.0);
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
