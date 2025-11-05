import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/user_model.dart';
import 'package:flutter_application_finote/views/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _Tugas10State();
}

class _Tugas10State extends State<RegisterFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController konfirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x75074799), Color(0xffE1FFBB)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.center,
          ),
        ),
        child: Stack(children: [buildLayer()]),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Daftar",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 80, 97, 119),
                  ),
                  textAlign: TextAlign.center,
                ),

                height(20),
                buildTitle("Nama Lengkap"),
                height(10),
                height(10),
                buildTextField(
                  hintText: "Masukkan Nama Lengkap Anda",
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama harus diisi";
                    }
                    return null;
                  },
                ),

                height(15),
                buildTitle("Email"),
                height(10),
                buildTextField(
                  hintText: "Masukkan email Anda",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email harus diisi";
                    } else if (!value.contains('@')) {
                      return "Email tidak valid";
                    } else if (!RegExp(
                      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
                    ).hasMatch(value)) {
                      return "Format Email tidak valid";
                    }
                    return null;
                  },
                ),

                height(15),

                buildTitle("Masukkan password"),
                height(10),
                buildTextField(
                  hintText: "Masukkan password Anda",
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password harus diisi";
                    }
                    return null;
                  },
                ),

                height(15),
                buildTitle("Konfirmasi password"),
                height(10),
                buildTextField(
                  hintText: "Masukkan kembali password Anda",
                  controller: konfirmController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password harus diisi";
                    } else if (value != passwordController.text) {
                      return "Password tidak sama";
                    }
                    return null;
                  },
                ),

                //Daftar
                height(20),
                Container(
                  width: 417.21,
                  height: 48.14,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(171, 116, 141, 174),
                    borderRadius: BorderRadius.circular(10.7),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(nameController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreenDay18(
                              // name: nameController.text,
                              // city: passwordController.text,
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Form belum dilengkapi"),
                              content: Text(
                                "Mohon isi Nama Lengkap, Email, dan Password",
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      final UserModel dataStudent = UserModel(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      DbHelper.registerUser(dataStudent).then((value) {
                        // emailC.clear();
                        // ageC.clear();
                        // //classC.clear();
                        // nameC.clear();
                        // getData();
                        Fluttertoast.showToast(
                          msg: "Data berhasil ditambahkan",
                        );
                      });
                    },
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        fontSize: 21.74,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

SizedBox height(double height) => SizedBox(height: height);
SizedBox width(double width) => SizedBox(width: width);

Widget buildTitle(String text) {
  return Row(
    children: [
      // Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
    ],
  );
}
