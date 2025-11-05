import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CreatePengeluaranModels extends StatefulWidget {
  final String? initialTanggal;
  const CreatePengeluaranModels({super.key, this.initialTanggal});

  @override
  State<CreatePengeluaranModels> createState() => _CreatePengeluaranModelsState();
}

class _CreatePengeluaranModelsState extends State<CreatePengeluaranModels> {
  final NotesPengeluaranC = TextEditingController();
  final TanggalKeluarC = TextEditingController();
  final JumlahPengeluaranC = TextEditingController();
  final KategoriPengeluaranC = TextEditingController();

// void initState(){
//   super.initState();
//   if(widget.initialTanggal != null){
//     TanggalKeluarC.text = widget.initialTanggal!;
//   }
// }

  getDataPengeluaran() {
    DbHelper.getAllPengeluaran();
    setState(() {});
  }

  Future<void> _onEdit(PengeluaranModel Pengeluaran) async {
    final editNotesPengeluaranC = TextEditingController(text: Pengeluaran.notesPengeluaran);
    final editJumlahPengeluaranC = TextEditingController(text: Pengeluaran.jumlahPengeluaran.toString());
    final editTanggalPengeluaranC = TextEditingController(text: Pengeluaran.tanggalKeluar);
    final editKategoriPengeluaranC = TextEditingController(text: Pengeluaran.kategoriPengeluaran);
    final editKategoriCatatanC = TextEditingController(text: Pengeluaran.kategoriCatatan);

    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit data Pengeluaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              buildTextField(hintText: "Catatan", controller: editNotesPengeluaranC),
              buildTextField(hintText: "Jumlah Pengeluaran (Rp.)", controller: editJumlahPengeluaranC),
              buildTextField(hintText: "Tanggal", controller: editTanggalPengeluaranC),
              buildTextField(hintText: "Kategori Pengeluaran", controller: editKategoriPengeluaranC),

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
    if (res == true) {
      int jumlah = 0;
      try{
        jumlah = int.parse(editJumlahPengeluaranC.text);
      } catch(e){
        Fluttertoast.showToast(msg: "Jumlah tidak valid");
        return;
      }
      final updated = PengeluaranModel(
        id: Pengeluaran.id,
        notesPengeluaran: editNotesPengeluaranC.text,
        jumlahPengeluaran: jumlah,
        tanggalKeluar: editKategoriPengeluaranC.text,
        kategoriCatatan: editKategoriCatatanC.text,

        kategoriPengeluaran: editKategoriPengeluaranC.text
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff9ECAD6), Color(0xffF5CBCB)],
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12,
            children: [
              Text("Daftar Pengeluaran", style: TextStyle(fontSize: 24)),
             
              FutureBuilder(
                future: DbHelper.getAllPengeluaran(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.data == null || snapshot.data.isEmpty) {
                    return Column(
                      children: [
                        //Image.asset("assets/images/empty.png", height: 150),

                        Text("Data belum ada"),
                      ],
                    );
                  } else {
                    final data = snapshot.data as List<PengeluaranModel>;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final items = data[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(items.notesPengeluaran),
                                subtitle: Text("${items.jumlahPengeluaran.toStringAsFixed(0)} • Rp ${items.tanggalKeluar}"),
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
                              SizedBox(height: 20,)
                            ],
                          );
                        },
                      ),
                    );
                  }
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
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
}
