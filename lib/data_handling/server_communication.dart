import 'dart:io';

import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:modbus/modbus.dart';

int count = 0;

Future<void> readFromDeviceLoop() async {
  /*
  1. read data point
  2. save data point in csv file (name is year, month)
  */
  // AlertsManager.addAlert(AlertModel(
  //   alertIcon: Icons.warning,
  //   errMsg: 'Ch0 - New Peak was Reached 3.1V',
  //   timeDate: DateTime.now().toString(),
  // ));
  if (!await pingIP(ipAddress: serverIpAdrs, port: serverPortNo)) {
    debugPrint('Error: Pinging or Socket check failed! ');
  }
  // else{debugPrint('Pinging & Socket check were successful! ');}
  ModbusClient client = createTcpClient(serverIpAdrs,
      port: serverPortNo, unitId: deviceId, mode: ModbusMode.rtu);
  // Map<String, double> filter = {
  //   'min': 0,
  //   'max': 0,
  //   'avg': 0,
  //   'p2p': 0,
  // };
  List<DataEntry> dataEntries = [];
  try {
    await client.connect();
    // if(client.)
    while (true) {
      List<int> values =
          await client.readInputRegisters(chAddresses[1] - 30001, 15);
      if (values.isNotEmpty) {
        debugPrint(values.toString());
        if (values[0] == 1) {
          // throw ('Gateway retruned an error. Rule-base Result is 1 which is an error according to modbus mapping in manual');
          // debugPrint(
          //     'Trial #${count++} Error connecting to / reading from Modbus server: \n    Gateway retruned an error. Rule-base Result is 1 which is an error according to modbus mapping in manual');
        }
        DataEntry dataEntry = DataEntry(
            dateTime: DateTime.now(),
            min: values[4] / 100,
            max: values[2] / 100,
            average: values[6] / 100,
            peak2Peak: values[10] / 100);
        debugPrint(dataEntry.toString());
        dataEntries.add(dataEntry);
      }
      if (dataEntries.length >= readingBuffer) {
        await saveToCsv(dataEntries);
        dataEntries = [];
      }
      // debugPrint('.len: ${dataEntries.length}');
      await Future.delayed(const Duration(milliseconds: serverReadingDelay));
      count = 0;
    }
  } catch (e) {
    // debugPrint(
    // 'Trial #${count++} Error connecting to / reading from Modbus server: ${e.toString()}');
    await Future.delayed(const Duration(milliseconds: serverReadingDelay));

    readFromDeviceLoop();
  } finally {
    await client.close();
  }
}

Future<bool> pingIP(
    {required String ipAddress,
    required int port,
    Duration timeout = const Duration(seconds: 5)}) async {
  bool didPing = false, isPortOpen = false;
  try {
    final result = await Process.run(
        'ping', ['-c', '1', '-W', timeout.toString(), ipAddress]);
    didPing = result.exitCode == 0;
  } catch (e) {
    debugPrint('Error pinging $ipAddress: $e');
    didPing = false;
  }

  try {
    final socket = await Socket.connect(ipAddress, port, timeout: timeout);
    await socket.close();
    isPortOpen = true;
  } catch (e) {
    debugPrint('Error checking $ipAddress:$port: $e');
    isPortOpen = false;
  }
  return (didPing & isPortOpen);
}
