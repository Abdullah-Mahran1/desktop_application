// File: lib/cubits/device_connection_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_application/const/data_singleton.dart';

// Connection States
abstract class DeviceState {}

class Connected extends DeviceState {}

class TryingToConnect extends DeviceState {}

class Disconnected extends DeviceState {}

// Device Connection Cubit
class DeviceConnectionCubit extends Cubit<DeviceState> {
  DeviceConnectionCubit()
      : super(_mapIsLiveGraphToState(DataSingleton().isLiveGraph));

  void checkConnectionState() {
    final newState = _mapIsLiveGraphToState(DataSingleton().isLiveGraph);
    if (state.runtimeType != newState.runtimeType) {
      emit(newState);
    }
  }

  void setTryingToConnect() {
    emit(TryingToConnect());
  }

  static DeviceState _mapIsLiveGraphToState(bool? isLiveGraph) {
    if (isLiveGraph == true) {
      return Connected();
    } else {
      return Disconnected();
    }
  }
}
