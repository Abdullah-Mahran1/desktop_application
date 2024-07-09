import 'dart:io';
import 'package:csv/csv.dart';

import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:modbus/modbus.dart';

Future<void> readDataContinuously() async {
  /*
  1. read data point
  2. save data point in csv file (name is year, month)
  */
  if (await pingIP(ipAddress: serverIpAdrs, port: serverPortNo)) {
    debugPrint('Pinging & Socket check were successful! ');
  }
  ModbusClient client = createTcpClient(serverIpAdrs,
      port: serverPortNo, unitId: 1, mode: ModbusMode.rtu);
  List<int> chAddresses = [30001, 30101, 30201, 30301];
  int readingBuffer =
      10; // number of elements to accumulate before storing to excel file, production version can have value of 50
  // Map<String, double> filter = {
  //   'min': 0,
  //   'max': 0,
  //   'avg': 0,
  //   'p2p': 0,
  // };
  List<DataEntry> dataEntries = [];
  int count = 0;
  try {
    await client.connect();
    // if(client.)
    while (true) {
      List<int> values =
          await client.readInputRegisters(chAddresses[0] - 30001, 15);
      if (values.isNotEmpty) {
        debugPrint(values.toString());
        if (values[0] == 1) {
          throw ('Gateway retruned an errorm Rule-base Result is 1 which is an error according to modbus mapping in manual');
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
        await saveToExcel(dataEntries);
        dataEntries = [];
      }
      // debugPrint('.len: ${dataEntries.length}');
      await Future.delayed(const Duration(milliseconds: 2000));
    }
  } catch (e) {
    debugPrint(
        'Trial #${count++} Error connecting to / reading from Modbus server ${e.toString()}');
    readDataContinuously();
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

Future<bool> saveToExcel(List<DataEntry> dataEntries) async {
  try {
    var file = File(
        'assets/data/${dataEntries[0].dateTime.toString().substring(0, 7)}.csv');
    // debugPrint('csv exists? ${file.existsSync()}');

    var csvData = file.existsSync()
        ? const CsvToListConverter().convert(await file.readAsString())
        : <List<dynamic>>[];
    // debugPrint('csv exists? ${file.existsSync()}');

    csvData.addAll(dataEntries.map((it) => it.toCSVRow()));
    String csv = const ListToCsvConverter().convert(csvData);
    await file.writeAsString(csv);
    debugPrint('Saved ✔');
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
