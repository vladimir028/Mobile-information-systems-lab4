import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/event.dart';
import 'navigation_screen.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _examController = TextEditingController();
  final TextEditingController _scheduledTimeController =
      TextEditingController();
  TimeOfDay? scheduledTime;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Event>? list;

  @override
  void initState() {
    // TODO: implement initState
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam session calendar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Event Name"),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Subject"),
                          controller: _examController,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Scheduled Time"),
                          controller: _scheduledTimeController,
                          readOnly: true,
                          onTap: _pickTime,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Latitude"),
                          controller: _latController,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Longitude"),
                          controller: _lngController,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          if (events[_selectedDay] != null) {
                            list = events[_selectedDay];
                            events.addAll({
                              _selectedDay: [
                                ...list!,
                                Event(
                                    _examController.text,
                                    scheduledTime!,
                                    _selectedDay,
                                    LatLng(double.parse(_latController.text),
                                        double.parse(_lngController.text)))
                              ]
                            });
                          } else {
                            events.addAll({
                              _selectedDay: [
                                Event(
                                    _examController.text,
                                    scheduledTime!,
                                    _selectedDay,
                                    LatLng(double.parse(_latController.text),
                                        double.parse(_lngController.text)))
                              ]
                            });
                          }
                          _examController.text = "";
                          _scheduledTimeController.text = "";
                          Navigator.of(context).pop();
                          _selectedEvents.value =
                              _getEventsForDay(_selectedDay);
                        },
                        child: const Text("Submit"))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Text("Selected day = ${_selectedDay.toString().split(" ")[0]}"),
          // ElevatedButton(onPressed: () {
          //   Navigator.pushNamed(context, "/location");
          // }, child: Text("Navigate"))
          // ,
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2010),
            lastDay: DateTime.utc(2030),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onPageChanged: (focusedDay) {
              _selectedDay = focusedDay;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        Event event = value[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            onTap: () => print(""),
                            title: Text(
                                'Exam: ${event.title}, Day: ${event.selectedDate}, Period: ${event.selectedTime}, '
                                    'Location:'
                                    'latitude: ${event.curLocation.latitude} '
                                    'longitude: ${event.curLocation.longitude}'),
                            subtitle: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NavigationScreen(
                                          double.parse(_latController.text),
                                          double.parse(_lngController.text))));
                                },
                                child: const Text("See location")),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        // _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime selectedDay) {
    return events[selectedDay] ?? [];
  }

  void _pickTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null && mounted) {
      final formattedTime = selectedTime.format(context);
      setState(() {
        _scheduledTimeController.text = formattedTime;
        scheduledTime =
            TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute);
      });
    }
  }
}
