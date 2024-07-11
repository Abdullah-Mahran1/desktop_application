import 'package:flutter_bloc/flutter_bloc.dart';

enum GraphXView { MINUTE, HOUR, SIX_HOURS, DAY, SIX_DAYS }

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  void updateGraphXView(GraphXView value) {
    emit(state.copyWith(graphXView: value));
  }

  void updatePowerRange(double min, double max) {
    emit(state.copyWith(powerRange: [min, max]));
  }

  void updateChannelThreshold(int channel, String operator, double value) {
    final newThresholds =
        Map<int, Map<String, double>>.from(state.channelThresholds);
    newThresholds[channel] = {operator: value};
    emit(state.copyWith(channelThresholds: newThresholds));
  }

  void saveSettings() {
    // Here you would typically save the settings to persistent storage
    // For now, we'll just print the current state
    print('Saving settings: ${state.toString()}');
  }
}

class SettingsState {
  final GraphXView graphXView;
  final List<double> powerRange;
  final Map<int, Map<String, double>> channelThresholds;

  SettingsState({
    required this.graphXView,
    required this.powerRange,
    required this.channelThresholds,
  });

  factory SettingsState.initial() {
    return SettingsState(
      graphXView: GraphXView.MINUTE,
      powerRange: [0, 80],
      channelThresholds: {
        0: {'>=': 3.7},
        1: {'<': 3.7},
        2: {'>=': 3.7},
        3: {'>=': 3.7},
      },
    );
  }

  SettingsState copyWith({
    GraphXView? graphXView,
    List<double>? powerRange,
    Map<int, Map<String, double>>? channelThresholds,
  }) {
    return SettingsState(
      graphXView: graphXView ?? this.graphXView,
      powerRange: powerRange ?? this.powerRange,
      channelThresholds: channelThresholds ?? this.channelThresholds,
    );
  }

  @override
  String toString() {
    return 'SettingsState(graphXView: $graphXView, powerRange: $powerRange, channelThresholds: $channelThresholds)';
  }
}
