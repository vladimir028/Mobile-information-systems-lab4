import 'package:flutter/material.dart';
import 'package:lab4/presentation/pages/calendar_page.dart';
import 'package:lab4/presentation/pages/test/location_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam session',
      initialRoute: '/',
      routes: {
        '/': (context) => const CalendarPage(),
        // TESTING PURPOSES
        '/location': (context) => const LocationPage(),
      },
    );
  }
}
