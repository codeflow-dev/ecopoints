// ignore_for_file: unused_label

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/login_page.dart';
import 'package:ecopoints/pages/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _navigateToSecondPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(role: widget.role)),
    );
  }

  Future signUp() async {
    try {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        final adminPasswordController = TextEditingController();
        final adminEmail = FirebaseAuth.instance.currentUser!.email!;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Enter your admin password to confirm"),
            content: TextField(
              controller: adminPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  showLoadingDialog(context);

                  final user = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  if (user.user != null) {
                    Map<String, dynamic> data = {
                      "firstName": _firstNameController.text.trim(),
                      "lastName": _lastNameController.text.trim(),
                    };
                    if (widget.role == "agent") {
                      data["bottle"] = 0;
                      data["carton"] = 0;
                      data["iron"] = 0;
                      data["paper"] = 0;
                      data["plastic"] = 0;
                      data["location"] = "Unknown";
                    } else {
                      data["points"] = 0;
                    }

                    await FirebaseFirestore.instance
                        .collection(widget.role)
                        .doc(user.user?.uid)
                        .set(
                          data,
                          SetOptions(merge: true),
                        );
                    if (mounted) {
                      Navigator.pop(context);
                      if (widget.role == "agent") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('New agent has been added'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: adminEmail,
                                      password:
                                          adminPasswordController.text.trim(),
                                    );
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserHomePage(),
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        );
      } else {
        showToast("Both password fields should be same.");
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message ?? "Error");
    } catch (e) {
      showToast(e.toString());
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello ${widget.role == 'agent' ? "Admin" : "User"} !",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 20),
                Text(
                  "Register with your info.",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.people_alt),
                        hintText: 'First Name',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.people_alt),
                        hintText: 'Last Name',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.email_rounded),
                        hintText: 'Email',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        fillColor: Colors.white,
                        icon: Icon(Icons.key_sharp),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                        fillColor: Colors.white,
                        icon: Icon(Icons.key_sharp),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: signUp,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.all(18),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.role == 'user')
                  Column(
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToSecondPage(context),
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
}
