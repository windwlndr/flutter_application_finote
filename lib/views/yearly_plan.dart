import 'package:flutter/material.dart';
import 'package:flutter_application_finote/widgets/list_item_widget.dart';

class RencanaTahunanPage extends StatefulWidget {
  const RencanaTahunanPage({super.key});

  @override
  State<RencanaTahunanPage> createState() => _RencanaTahunanPageState();
}

class _RencanaTahunanPageState extends State<RencanaTahunanPage> {
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
                "Daftar Rencana Tahunan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 16, 62, 100),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4DA1A9),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Tambah Rencana Tahunan"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Rencana"),
                    ),
                    TextField(decoration: InputDecoration(labelText: "Harga")),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Batal"),
                  ),
                  TextButton(
                    onPressed: () {
                      ListItemWidget(
                        itemIcon: Icons.event,
                        itemName: "Rencana Baru",
                        itemPrice: "08:00 AM",
                        itemDateTime: "Hari Ini",
                      );
                      // Simpan rencana Tahunan
                      Navigator.pop(context);
                    },
                    child: Text("Simpan"),
                  ),
                ],
              );
            },
          );
          setState(() {});
        },
        child: Icon(Icons.add, color: Color(0xff074799)),
      ),
    );
  }
}
