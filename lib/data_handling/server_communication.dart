import 'dart:async';
import 'dart:io';

import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/const/data_singleton.dart';
import 'package:desktop_application/cubits/device_connection_cubit.dart';
import 'package:desktop_application/data_handling/alerts_management.dart';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/models/alert_model.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modbus/modbus.dart';

int trialsCount = 0;
bool didPing = false, isPortOpen = false;

// List<DataEntry> serverData = [];
// int readingBuffer = 10; // Number of readings to buffer before saving to CSV
// int serverReadingDelay = 1000; // Delay between readings in milliseconds

Future<void> readFromDeviceLoop(BuildContext context) async {
  debugPrint('function readFromDeviceLoop was called');

  // Create a completer to handle the async operation
  final completer = Completer<void>();

  // Use a local variable to store the cubit
  final deviceConnectionCubit = context.read<DeviceConnectionCubit>();

  // Start the connection process
  deviceConnectionCubit.setTryingToConnect();

  // Use a separate function for the main loop logic
  _performDeviceLoop(deviceConnectionCubit, completer);

  // Return the future from the completer
  return completer.future;
}

Future<void> _performDeviceLoop(
    DeviceConnectionCubit cubit, Completer<void> completer) async {
  List<bool> didPingAndIsPortOpen =
      await pingIP(ipAddress: serverIpAdrs, port: serverPortNo);

  ModbusClient client = createTcpClient(serverIpAdrs,
      port: serverPortNo, unitId: deviceId, mode: ModbusMode.rtu);

  try {
    DataSingleton().isLiveGraph =
        didPingAndIsPortOpen[0] & didPingAndIsPortOpen[1];
    if (didPingAndIsPortOpen[0] & didPingAndIsPortOpen[1]) {
      debugPrint('Pinging & Socket check were successful!');
    } else {
      throw 'Error: Pinging or Socket check failed! ';
    }

    List<DataEntry> dataEntries = [];
    await client.connect();

    while (true) {
      // ... Your existing loop logic ...

      trialsCount = 0;
      DataSingleton().isDeviceConnected = true;
      cubit.checkConnectionState();

      await Future.delayed(const Duration(milliseconds: serverReadingDelay));
    }
  } catch (e) {
    debugPrint(
        'Trial #${trialsCount++} Error connecting to / reading from Modbus server: ${e.toString()}');
    if (trialsCount > 2) {
      AlertsManager.addAlert(AlertModel(
          errMsg:
              'Error connecting to device,\n [pinged = ${didPingAndIsPortOpen[0]}], [port open = ${didPingAndIsPortOpen[1]}]'));
      DataSingleton().isDeviceConnected = false;
      cubit.checkConnectionState();
    } else {
      await Future.delayed(const Duration(milliseconds: serverReadingDelay));
      _performDeviceLoop(cubit, completer);
    }
  } finally {
    await client.close();
    if (!completer.isCompleted) {
      completer.complete();
    }
  }
}

Future<List<bool>> pingIP(
    {required String ipAddress, required int port, int timeout = 10000}) async {
  bool didPing = true, isPortOpen = true;
  int exitCode = 10000000;
  try {
    final result = await Process.run('ping', ['-n', '1', ipAddress]);
    exitCode = result.exitCode;
    didPing = exitCode == 0;
  } catch (e) {
    debugPrint('Error pinging $ipAddress: $e');
    didPing = false;
  }

  try {
    final socket = await Socket.connect(ipAddress, port,
        timeout: Duration(milliseconds: timeout));
    await socket.close();
    isPortOpen = true;
  } catch (e) {
    debugPrint('Error checking $ipAddress:$port: $e');
    isPortOpen = false;
  }
  debugPrint(
      'didPing: $didPing, isPortOpen: $isPortOpen, exitCode = $exitCode');
  return [didPing, isPortOpen];
}
