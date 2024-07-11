// settings_page.dart
import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Settings')),
            body: Column(
              children: [
                DropdownButton<GraphXView>(
                  value: state.graphXView,
                  onChanged: (GraphXView? newValue) {
                    if (newValue != null) {
                      context.read<SettingsCubit>().updateGraphXView(newValue);
                    }
                  },
                  items: GraphXView.values.map((GraphXView view) {
                    return DropdownMenuItem<GraphXView>(
                      value: view,
                      child: Text(view.toString().split('.').last),
                    );
                  }).toList(),
                ),
                // Add other UI elements here...
                ElevatedButton(
                  onPressed: () {
                    context.read<SettingsCubit>().saveSettings();
                  },
                  child: Text('Save Settings'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
