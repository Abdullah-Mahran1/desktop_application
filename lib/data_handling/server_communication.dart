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
  context.read<DeviceConnectionCubit>().setTryingToConnect();
  /*
  1. read data point
  2. save data point in csv file (name is year, month)
  */
  // AlertsManager.addAlert(AlertModel(
  //   alertIcon: Icons.warning,
  //   errMsg: 'Ch0 - New Peak was Reached 3.1V',
  //   timeDate: DateTime.now().toString(),
  // ));
  List<bool> didPingAndIsPortOpen =
      await pingIP(ipAddress: serverIpAdrs, port: serverPortNo);

  ModbusClient client = createTcpClient(serverIpAdrs,
      port: serverPortNo, unitId: deviceId, mode: ModbusMode.rtu);
  try {
    DataSingleton().isLiveGraph =
        didPingAndIsPortOpen[0] & didPingAndIsPortOpen[1];
    if (didPingAndIsPortOpen[0] & didPingAndIsPortOpen[1]) {
      debugPrint('Pinging & Socket check were successful!');
      // debugPrint();
    } else {
      throw 'Error: Pinging or Socket check failed! ';
    }
    List<DataEntry> dataEntries = [];
    await client.connect();

    // if(client.)
    while (true) {
      List<int> values = await client.readInputRegisters(
          chAddresses[0], 15); /*(chAddresses[1], 15);*/
      if (values.isNotEmpty) {
        // debugPrint('Values variable is good, not empty');
        debugPrint(values.toString());
        if (values[0] == 1) {
          // throw ('Gateway retruned an error. Rule-base Result is 1 which is an error according to modbus mapping in manual');
          debugPrint(
              'Warning: Gateway retruned an error. Rule-base Result is 1 which is an error according to modbus mapping in manual');
        }
        DataEntry dataEntry = DataEntry(
            dateTime: DateTime.now(),
            min: values[4] / 100,
            max: values[2] / 100,
            average: values[6] / 100,
            peak2Peak: values[10] / 100);
        debugPrint(dataEntry.toString());
        dataEntries.add(dataEntry);
        // serverData.add(dataEntry);
      } else {
        throw ('Error: values variable is empty, read registers are empty');
      }
      if (dataEntries.length >= readingBuffer) {
        await saveToCsv(dataEntries);
        dataEntries = [];
      }
      // debugPrint('.len: ${dataEntries.length}');
      await Future.delayed(const Duration(milliseconds: serverReadingDelay));
      trialsCount = 0;
      DataSingleton().isDeviceConnected = true;
      context.read<DeviceConnectionCubit>().checkConnectionState();
    }
  } catch (e) {
    debugPrint(
        'Trial #${trialsCount++} Error connecting to / reading from Modbus server: ${e.toString()}');
    if (trialsCount > 2) {
      AlertsManager.addAlert(AlertModel(
          errMsg:
              'Error connecting to device,\n [pinged = ${didPingAndIsPortOpen[0]}], [port open = ${didPingAndIsPortOpen[1]}]'));
      DataSingleton().isDeviceConnected = false;
      context.read<DeviceConnectionCubit>().checkConnectionState();
    } else {
      await Future.delayed(const Duration(milliseconds: serverReadingDelay));
      readFromDeviceLoop(context);
    }
  } finally {
    await client.close();
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
