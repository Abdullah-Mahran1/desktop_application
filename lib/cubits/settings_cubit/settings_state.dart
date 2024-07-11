// import 'package:desktop_application/const/constants.dart';
// import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';

// // part of 'settings_cubit.dart';

// class SettingsState {
//   final GraphXView graphXView;
//   final List<double> powerRange;
//   final Map<int, Map<String, double>> channelThresholds;

//   SettingsState({
//     required this.graphXView,
//     required this.powerRange,
//     required this.channelThresholds,
//   });

//   factory SettingsState.initial() {
//     return SettingsState(
//       graphXView: currentXView,
//       powerRange: powerRange,
//       channelThresholds: channelThresholds,
//     );
//   }

//   SettingsState copyWith({
//     GraphXView? graphXView,
//     List<double>? powerRange,
//     Map<int, Map<String, double>>? channelThresholds,
//   }) {
//     return SettingsState(
//       graphXView: graphXView ?? this.graphXView,
//       powerRange: powerRange ?? this.powerRange,
//       channelThresholds: channelThresholds ?? this.channelThresholds,
//     );
//   }
// }
