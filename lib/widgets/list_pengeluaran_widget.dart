import 'package:flutter/material.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:intl/intl.dart';
import '../models/pengeluaran.dart';
import '../database/db_helper.dart';

class ListPengeluaranWidget extends StatefulWidget {
  final bool showOnlyPengeluaran; // kalau kamu mau filter jenis transaksi

  const ListPengeluaranWidget({super.key, this.showOnlyPengeluaran = true});

  @override
  State<ListPengeluaranWidget> createState() => _ListPengeluaranWidgetState();
}

class _ListPengeluaranWidgetState extends State<ListPengeluaranWidget> {
  late Future<List<PengeluaranModel>> _listPengeluaran;

  @override
  void initState() {
    super.initState();
    _listPengeluaran = DbHelper.getAllPengeluaran();
  }

  String _formatTanggal(String tanggal) {
    try {
      final date = DateFormat('dd MMMM yyyy', 'id_ID').parse(tanggal);
      return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return tanggal;
    }
  }

  // IconData _getIconKategori(String kategori) {
  //   switch (kategori.toLowerCase()) {
  //     case 'makan':
  //     case 'makan & minum':
  //       return Icons.fastfood;
  //     case 'transportasi':
  //       return Icons.directions_bus;
  //     case 'hiburan':
  //       return Icons.sports_esports;
  //     case 'tagihan':
  //       return Icons.receipt_long;
  //     case 'lain-lain':
  //       return Icons.more_horiz;
  //     default:
  //       return Icons.money;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PengeluaranModel>>(
      future: _listPengeluaran,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.data == null || snapshot.data.isEmpty) {
          return Column(
            children: [
              Image.asset("assets/images/EmptyNotes.png", height: 150),
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
                          items.kategoriPengeluaran == "Makan & Minum"
                              ? Icons.fastfood
                              : items.kategoriPengeluaran == "Transportasi"
                              ? Icons.motorcycle
                              : items.kategoriPengeluaran == "Hiburan"
                              ? Icons.games
                              : items.kategoriPengeluaran == "Tagihan"
                              ? Icons.note
                              : Icons.menu,
                          // ,color
                          // : items.kategoriPengeluaran ==
                          //       "Pengeluaran"
                          // ? Colors.red
                          // : Colors.green,
                        ),
                        title: Text(
                          items.notesPengeluaran,
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
                              items.tanggalKeluar,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       onPressed: () {
                        //         _onEdit.C(items);
                        //       },
                        //       icon: Icon(Icons.edit),
                        //     ),
                        //     IconButton(
                        //       onPressed: () {
                        //         _onDelete(items);
                        //       },
                        //       icon: Icon(
                        //         Icons.delete,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                      height(8),
                    ],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
