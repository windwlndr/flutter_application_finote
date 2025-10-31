import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/preferences/preferences_handler.dart';
import 'package:flutter_application_finote/views/home_page.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Bahas Shared Preference
class LoginScreenDay18 extends StatefulWidget {
  const LoginScreenDay18({super.key});
  //static const id = "/login_screen18";
  @override
  State<LoginScreenDay18> createState() => _LoginScreenDay18State();
}

class _LoginScreenDay18State extends State<LoginScreenDay18> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  login() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePageFinote()),
    );
  }

  final _formKey = GlobalKey<FormState>();
  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                height(12),
                Text(
                  "Login to access your account",
                  // style: TextStyle(fontSize: 14, color: AppColor.gray88),
                ),
                height(24),
                buildTitle("Email Address"),
                height(12),
                buildTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong";
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

                height(16),
                buildTitle("Password"),
                height(12),
                buildTextField(
                  hintText: "Enter your password",
                  isPassword: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password tidak boleh kosong";
                    // } else if (value.length < 6) {
                    //   return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),
                height(12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomeScreen()),
                      // );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MeetSebelas()),
                      // );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 12,
                        // color: AppColor.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                height(24),
                LoginButton(
                  text: "Login",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(emailController.text);
                      PreferenceHandler.saveLogin(true);
                      final data = await DbHelper.loginUser(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (data != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePageFinote(),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Akun belum terdaftar",
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Validation Error"),
                            content: Text("Please fill all fields"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text("Ga OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Or Sign In With",
                      // style: TextStyle(fontSize: 12, color: AppColor.gray88),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8),

                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                height(16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Navigate to MeetLima screen menggunakan pushnamed
                      Navigator.pushNamed(context, "/meet_2");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Google_Icons.png",
                          height: 16,
                          width: 16,
                        ),
                        width(4),
                        Text("Google"),
                      ],
                    ),
                  ),
                ),
                height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      // style: TextStyle(fontSize: 12, color: AppColor.gray88),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterFormPage(),
                          ),
                        );
                        // context.push(RegisterScreen());
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MeetEmpatA()),
                        // );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          // color: AppColor.blueButton,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff9ECAD6), Color(0xffF5CBCB)],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight,
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
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                  // color: AppColor.gray88,
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
        // Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
      ],
    );
  }
}
