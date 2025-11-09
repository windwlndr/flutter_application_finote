import 'package:flutter/material.dart';
import 'package:flutter_application_finote/widgets/app_bar.dart';
import 'package:flutter_application_finote/widgets/list_item_widget.dart';

class RencanaMingguanPage extends StatefulWidget {
  const RencanaMingguanPage({super.key});

  @override
  State<RencanaMingguanPage> createState() => _RencanaMingguanPageState();
}

class _RencanaMingguanPageState extends State<RencanaMingguanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Finote',
        onSearchTap: () {
          print('Search tapped');
        },
        onNotificationTap: () {
          print('Notification tapped');
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x352F59AB), Color(0x102F59AB)],
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
                "Daftar Rencana Mingguan",
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
                title: Text("Tambah Rencana Mingguan"),
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
                      // Simpan rencana Mingguan
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
