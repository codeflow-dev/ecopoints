// ignore_for_file: require_trailing_commas, non_constant_identifier_names, override_on_non_overriding_member, prefer_const_constructors_in_immutables, avoid_print, use_build_context_synchronously

import 'package:ecopoints/pages/agent_home.dart';
import 'package:ecopoints/pages/home_page.dart';
import 'package:ecopoints/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String role;
  // LoginPage({super.key, required this.showRegisterPage, this.role = 'admin'});
  LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  void _navigateToSecondPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage(role: widget.role)),
    );
  }

  Future Login() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("Loading"),
            ],
          ),
        ),
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      Navigator.pop(context);
      if (widget.role == "agent") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AgentHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome Back!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 20),
            Text(
              "Make the world greener!",
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
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.email_rounded),
                      hintText: 'Email',
                      fillColor: Colors.white),
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
            GestureDetector(
              onTap: Login,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(9)),
                padding: EdgeInsets.all(18),
                child: Center(
                  child: Text(
                    'Login',
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
            Text(
              "Don't have an account?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _navigateToSecondPage(context),
              child: Text(
                "Register Now",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
