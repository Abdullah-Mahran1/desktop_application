import 'package:desktop_application/cubits/ch_selector_cubit.dart';
import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String graphTimeScale = GraphXView.MINUTE.toString();
  double powerRange = 40; // Starting at middle value
  Map<String, Map<String, dynamic>> channelThresholds = {
    'Ch0': {'operator': '>=', 'value': 3.7},
    'Ch1': {'operator': '<', 'value': 3.7},
    'Ch2': {'operator': '>=', 'value': 3.7},
    'Ch3': {'operator': '>=', 'value': 3.7},
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 51,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Graph Time Scale',
                  border: OutlineInputBorder(),
                ),
                value: graphTimeScale,
                onChanged: (String? newValue) {
                  setState(() {
                    graphTimeScale = newValue!;
                  });
                },
                items: GraphXView.values.map((view) {
                  return DropdownMenuItem<String>(
                    value: view.toString(),
                    child: Text(view.name),
                  );
                }).toList()),
            const SizedBox(height: 8),
            const Text('How much time should the graph show?',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Power range'),
            Slider(
              value: powerRange,
              min: 0,
              max: 80,
              divisions: 80,
              label: powerRange.round().toString(),
              onChanged: (double value) {
                setState(() {
                  powerRange = value;
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0 dB', style: TextStyle(fontSize: 12)),
                Text('80 dB', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
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
            ...channelThresholds.entries.map(
                (entry) => _buildChannelThresholdRow(entry.key, entry.value)),
            const Text(
                'Define the values that upon exceeding, you will get an alert',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelThresholdRow(
      String channel, Map<String, dynamic> threshold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(channel)),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: threshold['operator'],
            onChanged: (String? newValue) {
              setState(() {
                channelThresholds[channel]!['operator'] = newValue!;
              });
            },
            items: <String>['>', '<', '=', '>=', '<=']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: threshold['value'].toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffix: Text('mV'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  channelThresholds[channel]!['value'] =
                      double.tryParse(value) ?? threshold['value'];
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
        child: const Text('Save Settings'),
      ),
    );
  }

  void _saveSettings() {
    // Implement your save logic here

    debugPrint('Graph Time Scale: $graphTimeScale');
    BlocProvider.of<SettingsCubit>(context)
        .updateGraphXView(GraphXView.values.firstWhere(
      (e) => e.toString().split('.').last == graphTimeScale.toUpperCase(),
      orElse: () => GraphXView.MINUTE, // Default value if no match is found
    ));
    debugPrint('Power Range: $powerRange');
    BlocProvider.of<SettingsCubit>(context)
        .updatePowerRange(powerRange - 5, powerRange + 5);
    debugPrint('Channel Thresholds: $channelThresholds');
    for (String key in channelThresholds.keys) {
      BlocProvider.of<SettingsCubit>(context).updateChannelThreshold(
          int.parse(key[-1]),
          channelThresholds[key]!['operator'],
          channelThresholds[key]!['value']);
    }
    debugPrint('Settings saved');
    // You would typically send this data to your state management solution or backend here
  }
}
