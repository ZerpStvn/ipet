import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/widgets/eventview.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class UserAppointmentcheck extends StatefulWidget {
  final bool isvetadmin;
  const UserAppointmentcheck({super.key, required this.isvetadmin});

  @override
  State<UserAppointmentcheck> createState() => _UserAppointmentcheckState();
}

class _UserAppointmentcheckState extends State<UserAppointmentcheck> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<AppointEvent>> events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchData() async {
    try {
      final provider = Provider.of<AuthProviderClass>(context, listen: false);
      final snapshot = await FirebaseFirestore.instance
          .collection(
              widget.isvetadmin == false ? 'userappointment' : 'appointment')
          .doc(provider.userModel!.vetid)
          .collection(widget.isvetadmin == false ? 'user' : 'vet')
          .get();

      // final List<Map<String, dynamic>> fetchedData =
      //     snapshot.docs.map((doc) => doc.data()).toList();

      Map<DateTime, List<AppointEvent>> newEvents = {};
      for (var doc in snapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;

        Timestamp timestamp = data['appoinmentdate'];
        DateTime dateTime = timestamp.toDate();
        DateTime dateOnly =
            DateTime(dateTime.year, dateTime.month, dateTime.day);

        String formattedDate = DateFormat('EEE, M/d/y').format(dateOnly);
        if (newEvents[dateOnly] == null) {
          newEvents[dateOnly] = [];
        }

        newEvents[dateOnly]!.add(AppointEvent(
          name: data['clinic'],
          status: data['status'],
          date: formattedDate,
          vetid: doc.id,
          userid: data['userid'],
          username: data['name'],
        ));

        debugPrint('Events ID: ${doc.id}');
      }

      setState(() {
        events = newEvents;
      });
    } catch (error) {
      debugPrint("Error fetching data: $error");
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: widget.isvetadmin == false ? 50 : 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              eventLoader: (day) {
                DateTime dateOnly = DateTime(day.year, day.month, day.day);
                debugPrint("event date ${events[dateOnly] ?? []}");
                return events[dateOnly] ?? [];
              },
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
            ),
          ),
          if (_selectedDay != null &&
              events[DateTime(_selectedDay!.year, _selectedDay!.month,
                      _selectedDay!.day)] !=
                  null)
            Center(
              child: DataTable(
                columns: const [
                  DataColumn(label: MainFont(title: "Appoi...")),
                  DataColumn(label: MainFont(title: "Status")),
                  DataColumn(label: MainFont(title: "Action")),
                ],
                rows: events[DateTime(_selectedDay!.year, _selectedDay!.month,
                        _selectedDay!.day)]!
                    .map((event) {
                  return DataRow(cells: [
                    DataCell(MainFont(
                        title: truncateWithEllipsis(
                            widget.isvetadmin == true ? 11 : 7,
                            widget.isvetadmin == false
                                ? event.name
                                : event.username))),
                    DataCell(Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: renderColor(event.status),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MainFont(
                        color: Colors.white,
                        title: event.status == 0
                            ? "Active"
                            : event.status == 1
                                ? "Cancelled"
                                : "Done",
                      ),
                    )),
                    DataCell(GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventViewFormat(
                                      istitle: false,
                                      vetid: event.vetid,
                                      isadmin: widget.isvetadmin,
                                    )));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: maincolor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const MainFont(
                            color: Colors.white, title: "View.."),
                      ),
                    )),
                  ]);
                }).toList(),
              ),
            )
          else
            const SizedBox(
              height: 250,
              child: Center(
                child: MainFont(title: "You Don't Have Any Appointments"),
              ),
            ),
        ],
      ),
    );
  }

  Color renderColor(int status) {
    switch (status) {
      case 0:
        return maincolor;
      case 1:
        return Colors.redAccent;
      default:
        return maincolor;
    }
  }
}

class AppointEvent {
  String name;
  int status;
  String date;
  String vetid;
  String username;
  String userid;

  AppointEvent(
      {required this.vetid,
      required this.userid,
      required this.username,
      required this.name,
      required this.status,
      required this.date});
}
