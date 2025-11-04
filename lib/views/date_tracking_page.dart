import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/list_item_widget.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<List<PengeluaranModel>> _listPengeluaran;
  final NotesPengeluaranC = TextEditingController();
  final TanggalKeluarC = TextEditingController();
  final JumlahPengeluaranC = TextEditingController();
  final KategoriPengeluaranC = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? selectedPicked;
  String? dropDownKategori;
  final List<String> listKategori = [
    "Makan & Minum",
    "Transportasi",
    "Hiburan",
    "Tagihan",
    "Belanja",
    "Lain-lain",
  ];
  final List<String> listKategoriPemasukan = [
    "Gaji",
    "Bonus",
    "Hadiah",
    "Lain-lain",
  ];
  final List<String> listTransaksi = ["Pengeluaran", "Pemasukan"];

  getDataPengeluaran() {
    _listPengeluaran = DbHelper.getAllPengeluaran();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataPengeluaran();
  }

  Future<void> _onEdit(PengeluaranModel Pengeluaran) async {
    print(Pengeluaran.toMap());
    final editNotesPengeluaranC = TextEditingController(
      text: Pengeluaran.notesPengeluaran,
    );
    final editJumlahPengeluaranC = TextEditingController(
      text: Pengeluaran.jumlahPengeluaran.toString(),
    );

    DateTime selectedDate;
    try {
      selectedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).parse(Pengeluaran.tanggalKeluar);
    } catch (e) {
      selectedDate = DateTime.now();
    }

    String selectedKategori = Pengeluaran.kategoriPengeluaran;

    final editTanggalPengeluaranC = TextEditingController(
      text: Pengeluaran.tanggalKeluar.toString(),
    );
    // final editKategoriPengeluaranC = TextEditingController(
    //   text: Pengeluaran.kategoriPengeluaran,
    // );

    final res = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String formatedDate = DateFormat(
              'dd MMMM yyyy',
              'id_ID',
            ).format(selectedDate);

            return AlertDialog(
              title: Text("Edit data Pengeluaran"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  buildTextField(
                    hintText: "Catatan",
                    controller: editNotesPengeluaranC,
                  ),
                  buildTextField(
                    hintText: "Jumlah Pengeluaran (Rp.)",
                    controller: editJumlahPengeluaranC,
                  ),
                  buildTextField(
                    hintText: "Tanggal",
                    controller: editTanggalPengeluaranC,
                  ),
                  DropdownButton(
                    hint: const Text(
                      "Pilih Kategori",
                      style: TextStyle(
                        color: Color(0xff2E5077),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: dropDownKategori,
                    items: listKategori.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownKategori = value;
                      });
                    },
                  ),
                  // buildTextField(
                  //   hintText: "Kategori Pengeluaran",
                  //   controller: editKategoriPengeluaranC,
                  // ),
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
                    Navigator.pop(context, true);
                  },
                  child: Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
    if (res == true) {
      int jumlah = 0;
      try {
        jumlah = int.parse(editJumlahPengeluaranC.text);
      } catch (e) {
        Fluttertoast.showToast(msg: "Jumlah tidak valid");
        return;
      }
      final updated = PengeluaranModel(
        id: Pengeluaran.id,
        notesPengeluaran: editNotesPengeluaranC.text,
        jumlahPengeluaran: jumlah,
        tanggalKeluar: editTanggalPengeluaranC.text,
        kategoriPengeluaran: dropDownKategori ?? selectedKategori,
      );
      await DbHelper.updatePengeluaran(updated);
      getDataPengeluaran();
      Fluttertoast.showToast(msg: "Pengeluaran berhasil di update");
    }
  }

  Future<void> _onDelete(PengeluaranModel Pengeluaran) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                "Apakah anda yakin ingin menghapus data ${Pengeluaran.notesPengeluaran}?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Jangan"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Ya, hapus data"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      await DbHelper.deletePengeluaran(Pengeluaran.id!);
      getDataPengeluaran();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateText = selectedPicked != null
        ? DateFormat('dd MMMM yyyy', "id_ID").format(selectedPicked!)
        : DateFormat('dd MMMM yyyy', "id_ID").format(DateTime.now());
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                LoginButton(
                  text: "Tambah Catatan",
                  onPressed: () async {
                    String? dropDownJenis;
                    String? dropDownKategori;
                    TextEditingController catatanC = TextEditingController();
                    TextEditingController jumlahC = TextEditingController();
                    DateTime selectedDate = DateTime.now();
                    String formattedDate = DateFormat(
                      'dd MMMM yyyy',
                      'id_ID',
                    ).format(selectedDate);

                    final bool? result = await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            final kategoriList = dropDownJenis == "Pemasukan"
                                ? listKategoriPemasukan
                                : listKategori;

                            final jumlahColor = dropDownJenis == "Pemasukan"
                                ? Colors.green
                                : dropDownJenis == "Pengeluaran"
                                ? Colors.red
                                : Colors.black;

                            return AlertDialog(
                              title: const Text("Tambah Catatan"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: catatanC,
                                    decoration: const InputDecoration(
                                      labelText: "Catatan",
                                    ),
                                  ),
                                  // DropdownButton<String>(
                                  //   hint: const Text(
                                  //     "Pilih Jenis Catatan",
                                  //     style: TextStyle(
                                  //       color: Color(0xff2E5077),
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  //   value: dropDownKategori,
                                  //   items: listTransaksi.map((String val) {
                                  //     return DropdownMenuItem(
                                  //       value: val,
                                  //       child: Text(
                                  //         val,
                                  //         style: const TextStyle(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       dropDownKategori = value;
                                  //     });
                                  //   },
                                  // ),

                                  //Dropdown Kategori
                                  DropdownButton<String>(
                                    hint: const Text(
                                      "Pilih Jenis Catatan",
                                      style: TextStyle(
                                        color: Color(0xff2E5077),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: dropDownJenis,
                                    isExpanded: true,
                                    items: listKategori.map((String val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        dropDownJenis = value;
                                        dropDownKategori = null;
                                      });
                                    },
                                  ),

                                  //Dropdown Kategori
                                  DropdownButton<String>(
                                    hint: const Text(
                                      "Pilih Kategori",
                                      style: TextStyle(
                                        color: Color(0xff2E5077),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: dropDownKategori,
                                    items: listKategori.map((String val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        dropDownKategori = value;
                                      });
                                    },
                                  ),
                                  TextField(
                                    controller: jumlahC,
                                    decoration: const InputDecoration(
                                      labelText: "Jumlah",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        locale: const Locale('id', 'ID'),
                                        initialDate: selectedDate,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                          formattedDate = DateFormat(
                                            'dd MMMM yyyy',
                                            'id_ID',
                                          ).format(pickedDate);
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Tanggal",
                                          hintText: formattedDate,
                                        ),
                                        controller: TextEditingController(
                                          text: formattedDate,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // tampilkan item baru
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Catatan: ${catatanC.text}\nKategori: $dropDownKategori\nTanggal: $formattedDate',
                                        ),
                                      ),
                                    );
                                    final PengeluaranModel dataPengeluaran =
                                        PengeluaranModel(
                                          notesPengeluaran: catatanC.text,
                                          tanggalKeluar: formattedDate,
                                          jumlahPengeluaran: int.parse(
                                            jumlahC.text,
                                          ),
                                          kategoriPengeluaran:
                                              dropDownKategori!,
                                        );

                                    DbHelper.insertPengeluaran(
                                      dataPengeluaran,
                                    ).then((value) {
                                      Fluttertoast.showToast(
                                        msg: "Data berhasil ditambahkan",
                                      );
                                    });

                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Simpan"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                    if (result == true) {
                      setState(() {
                        getDataPengeluaran();
                      });
                    }
                  },
                ),
                height(8),
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
                              final jumlahColor =
                                  listKategoriPemasukan.contains(
                                    items.kategoriPengeluaran,
                                  )
                                  ? Colors.green
                                  : Colors.red;
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
                                          : items.kategoriPengeluaran ==
                                                "Belanja"
                                          ? Icons.trolley
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _onEdit(items);
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _onDelete(items);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextFormField buildTextField({
  String? hintText,
  bool isPassword = false,
  TextEditingController? controller,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
    ),
  );
}
