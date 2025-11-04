import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/list_item_widget.dart';
import 'package:flutter_application_finote/widgets/list_pengeluaran_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<PengeluaranModel>> _listPengeluaran;
  String? dropDownValue;
  final List<String> listKategori = ["Hari Ini", "Bulan Ini", "Tahun Ini"];

  getDataPengeluaran() {
    _listPengeluaran = DbHelper.getAllPengeluaran();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataPengeluaran();
  }

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
          child: SizedBox(
            height: 3000,
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
                        children: [
                          Icon(Icons.arrow_upward),
                          Text("Pengeluaran"),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_downward),
                          Text("Pemasukan"),
                        ],
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
                          child: Text(
                            val,
                            style: TextStyle(color: Colors.black),
                          ),
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

                FutureBuilder(
                  future: _listPengeluaran,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.data == null || snapshot.data.isEmpty) {
                      return Column(
                        children: [
                          Image.asset(
                            "assets/images/EmptyNotes.png",
                            height: 150,
                          ),
                          Text("Catatan belum ada"),
                        ],
                      );
                    } else {
                      final data = snapshot.data as List<PengeluaranModel>;
                      return Expanded(
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Color(0xff9ECAD6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final items = data[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      items.kategoriPengeluaran ==
                                              "Makan & Minum"
                                          ? Icons.fastfood
                                          : items.kategoriPengeluaran ==
                                                "Transportasi"
                                          ? Icons.motorcycle
                                          : items.kategoriPengeluaran ==
                                                "Hiburan"
                                          ? Icons.sports_esports
                                          : items.kategoriPengeluaran ==
                                                "Tagihan"
                                          ? Icons.receipt_long
                                          : Icons.menu,
                                    ),
                                    title: Text(
                                      "${items.notesPengeluaran}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2E5077),
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          "Rp ${items.jumlahPengeluaran.toStringAsFixed(0)}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        width(8),
                                        Text(
                                          "${items.tanggalKeluar}",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(thickness: 0.1, color: Colors.black),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ListItemWidget(
                //       itemIcon: Icons.coffee,
                //       itemName: "Kopi",
                //       itemPrice: "Rp 12.000",
                //       itemDateTime: "Hari ini, 10.30 WIB",
                //       priceColor: Colors.red,
                //     ),
                //     SizedBox(height: 8),
                //     ListItemWidget(
                //       itemIcon: Icons.food_bank,
                //       itemName: "Makan Siang",
                //       itemPrice: "Rp 20.000",
                //       itemDateTime: "Hari ini, 12.15 WIB",
                //       priceColor: Colors.red,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
