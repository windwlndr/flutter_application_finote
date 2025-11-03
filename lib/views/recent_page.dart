import 'package:flutter/material.dart';
import 'package:flutter_application_finote/widgets/list_item_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? dropDownValue;
  final List<String> listKategori = ["Hari Ini", "Bulan Ini", "Tahun Ini"];
  @override
  Widget build(BuildContext context) {
    String kategori = "Makan";
    double currentValue = 1200; // realisasi
    double targetValue = 1500; // target
    double progress = currentValue / targetValue;

    String pickedText = dropDownValue != null
        ? dropDownValue!.toString()
        : 'Pilih Kategori';
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
                "Transaksi Terkini",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2E5077),
                ),
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_upward), Text("Pengeluaran")],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_downward), Text("Pemasukan")],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Text(
              //   "Bulan Ini",
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Color(0xff2E5077),
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 12),
                  DropdownButton(
                    hint: Text(
                      "Pilih Periode",
                      style: TextStyle(
                        color: Color(0xff2E5077),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: dropDownValue,
                    items: listKategori.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(val, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownValue = value;
                      });
                      print(dropDownValue);
                    },
                  ),
                ],
              ),

              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListItemWidget(
                    itemIcon: Icons.coffee,
                    itemName: "Kopi",
                    itemPrice: "Rp 12.000",
                    itemDateTime: "Hari ini, 10.30 WIB",
                    priceColor: Colors.red,
                  ),
                  SizedBox(height: 8),
                  ListItemWidget(
                    itemIcon: Icons.food_bank,
                    itemName: "Makan Siang",
                    itemPrice: "Rp 20.000",
                    itemDateTime: "Hari ini, 12.15 WIB",
                    priceColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
