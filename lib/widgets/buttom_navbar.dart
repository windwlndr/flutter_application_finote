import 'package:flutter/material.dart';
import 'package:flutter_application_finote/views/home_page.dart';
import 'package:flutter_application_finote/views/recent_page.dart';

class ButtomNavbarWidgets extends StatefulWidget {
  const ButtomNavbarWidgets({super.key});

  @override
  State<ButtomNavbarWidgets> createState() => _ButtomNavbarWidgetsState();
}

class _ButtomNavbarWidgetsState extends State<ButtomNavbarWidgets> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    HomePageFinote(),
    HistoryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      //appBar: AppBar(title: Text("Finote"),),
      body: Container(
        height: 1000,
        width: 500,
        color: Color(0xff9ECAD6),
        // decoration: const BoxDecoration(gradient: LinearGradient(
        //     begin: Alignment.topLeft,   // arah awal
        //     end: Alignment.bottomRight, // arah akhir
        //     colors: [
        //       Color(0xFF9ECAD6), // biru
        //       Color(0xFFF5CBCB), // biru muda
        //     ],
        //   ),),
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0x75E1FFBB),
        currentIndex: _selectedIndex,
        onTap: (index) {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home Page"),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Transaksi Terkini",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Tambah Catatan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}


