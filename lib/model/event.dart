import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  final String title;
  final TimeOfDay selectedTime;
  final DateTime selectedDate;
  final LatLng curLocation;

  Event(this.title, this.selectedTime, this.selectedDate, this.curLocation);
}