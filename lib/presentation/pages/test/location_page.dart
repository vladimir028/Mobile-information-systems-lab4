import 'package:flutter/material.dart';

import '../navigation_screen.dart';

// TESTING PURPOSES!!!!
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Enter your location',
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: latController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'latitude',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: lngController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'longitute',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationScreen(
                          double.parse(latController.text),
                          double.parse(lngController.text))));
                },
                child: const Text('Get Directions')),
          ),
        ]),
      ),
    );
  }
}
