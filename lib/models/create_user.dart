import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CRWidgetDay19 extends StatefulWidget {
  const CRWidgetDay19({super.key});

  @override
  State<CRWidgetDay19> createState() => _CRWidgetDay19State();
}

class _CRWidgetDay19State extends State<CRWidgetDay19> {
  final nameC = TextEditingController();
  //final ageC = TextEditingController();
  final emailC = TextEditingController();
  //final classC = TextEditingController();
  getData() {
    DbHelper.getAllUser();
    setState(() {});
  }

  Future<void> _onEdit(UserModel user) async {
    final editNameC = TextEditingController(text: user.name);
    final editEmailC = TextEditingController(text: user.email);
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit data user"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              buildTextField(hintText: "Nama", controller: editNameC),
              buildTextField(hintText: "Email", controller: editEmailC),
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
      final updated = UserModel(
        id: user.id,
        name: editNameC.text,
        email: editEmailC.text,
      );
      DbHelper.updateUser(updated);
      getData();
      Fluttertoast.showToast(msg: "Data berhasil di update");
    }
  }

  Future<void> _onDelete(UserModel user) async {
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
                "Apakah anda yakin ingin menghapus data ${user.name}?",
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
              child: Text("Ya, hapus aja"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      DbHelper.deleteUser(user.id!);
      getData();
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
              Text("Daftar User", style: TextStyle(fontSize: 24)),
             
              FutureBuilder(
                future: DbHelper.getAllUser(),
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
                    final data = snapshot.data as List<UserModel>;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final items = data[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(items.name ?? ''),
                                subtitle: Text(items.email ?? ''),
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
