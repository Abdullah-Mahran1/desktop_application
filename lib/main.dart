import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/data_handling/server_communication.dart';
import 'package:desktop_application/models/icon_data_hive.dart';
import 'package:desktop_application/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/alert_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up a listener for the application closing event
  // const MethodChannel('flutter/platform')
  //     .setMethodCallHandler((MethodCall call) async {
  //   if (call.method == 'AppLifecycleState.detached') {
  //     // Application is closing, perform cleanup
  //     saveToCsv(null);
  //   }
  //   return null;
  // });
  await Hive.initFlutter();
  Hive.registerAdapter(AlertModelAdapter());
  Hive.registerAdapter(IconDataAdapter());
  await Hive.openBox<AlertModel>('alertsWiseDashboard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initFunction() async {
    readFromDeviceLoop();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initFunction();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(backgroundColor),
        brightness: Brightness.light,
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
