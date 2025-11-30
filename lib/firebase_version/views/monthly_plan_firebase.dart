import 'package:flutter/material.dart';
import 'package:flutter_application_finote/firebase_version/models/monthly_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';

class RencanaBulananFirebase extends StatefulWidget {
  const RencanaBulananFirebase({super.key});

  @override
  State<RencanaBulananFirebase> createState() => _RencanaBulananFirebaseState();
}

class _RencanaBulananFirebaseState extends State<RencanaBulananFirebase> {
  final TextEditingController rencanaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 218, 235, 255),
          title: const Text("Tambah Rencana Bulanan"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: rencanaController,
                  decoration: const InputDecoration(labelText: "Rencana"),
                ),
                TextField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Harga"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                rencanaController.clear();
                hargaController.clear();
                Navigator.pop(context);
              },
              child: const Text("Batal", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                final rencana = rencanaController.text.trim();
                final harga = int.tryParse(hargaController.text.trim()) ?? 0;

                if (rencana.isNotEmpty && harga > 0) {
                  await FirebaseService.tambahRencanaBulanan(
                    rencana: rencana,
                    harga: harga,
                  );
                }

                rencanaController.clear();
                hargaController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void ShowDeleteConfirm(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Rencana"),
          content: Text("Apakah Anda yakin ingin menghapus rencana ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal", style: TextStyle(color: Colors.green)),
            ),

            TextButton(
              onPressed: () async {
                await FirebaseService.hapusRencanaBulanan(id);
                Navigator.pop(context);
              },
              child: Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget buildItem(RencanaBulananModelFirebase item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          Icons.event_note,
          color: item.selesai ? Colors.green : Colors.blue,
        ),
        title: Text(
          item.rencana,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: item.selesai
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text("Rp ${item.harga}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // checklist
            IconButton(
              icon: Icon(
                item.selesai ? Icons.check_circle : Icons.check_circle_outline,
                color: Colors.green,
              ),
              onPressed: () {
                FirebaseService.updateMonthChecklist(
                  id: item.id,
                  status: !item.selesai,
                );
              },
            ),

            // delete
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: () {
                ShowDeleteConfirm(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rencana Bulanan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff2F59AB),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x352F59AB), Color(0x102F59AB)],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Daftar Rencana Bulanan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 16, 62, 100),
                ),
              ),
              const SizedBox(height: 20),

              // STREAM BUILDER - Realtime Data
              Expanded(
                child: StreamBuilder<List<RencanaBulananModelFirebase>>(
                  stream: FirebaseService.getRencanaBulanan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 100,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text("Belum ada rencana bulanan"),
                          ],
                        ),
                      );
                    }

                    final items = snapshot.data!;

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => buildItem(items[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2F59AB),
        onPressed: showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
