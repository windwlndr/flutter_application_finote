import 'package:flutter/material.dart';
import 'package:flutter_application_finote/views/home_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x75074799), Color(0xffE1FFBB)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.center,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.coffee),
                title: Text(
                  "Kopi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0x75074799),
                  ),
                ),
                subtitle: Text("-Rp. 20.000", style: TextStyle(fontSize: 12, color: Colors.red)),
                // trailing: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Icon(Icons.favorite),
                //     SizedBox(width: 8),
                //     Icon(Icons.trolley),
                //     SizedBox(width: 8),
                //     Icon(Icons.share),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
