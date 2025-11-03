import 'package:flutter/material.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? selectedPicked;

  @override
  void initState() {
    super.initState();
    //initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    String dateText = selectedPicked != null
        ? DateFormat('dd MMMM yyyy', "id_ID").format(selectedPicked!)
        : 'Pilih tanggal lahir';
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 30)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, size: 30),
          ),
        ],
        title: const Text(
          'Finote',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 16, 62, 100),
          ),
        ),
        backgroundColor: Color(0x75074799),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x75074799), Color(0xffE1FFBB)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.center,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tambahkan Catatan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2E5077),
                ),
              ),
              SizedBox(height: 20),

              TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(selectedPicked, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedPicked = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              SizedBox(height: 20),

              // ElevatedButton(
              //   onPressed: () async {
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       locale: const Locale("id", "ID"),
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime(2000),
              //       lastDate: DateTime(2100),
              //     );
              //     if (pickedDate != null) {
              //       setState(() {
              //         selectedPicked = pickedDate;
              //       });
              //     }
              //   },
              //   child: Text(dateText),
              // ),
              LoginButton(text: "Tambah Catatan", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
