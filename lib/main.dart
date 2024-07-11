import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/models/icon_data_hive.dart';
import 'package:desktop_application/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/alert_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AlertModelAdapter());
  Hive.registerAdapter(IconDataAdapter());
  await Hive.openBox<AlertModel>('alertsWiseDashboard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(backgroundColor),
        brightness: Brightness.light,
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}
