import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future getUser() async {
    var user =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text("User does not exist")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          firstNameController.text = data["firstName"];
          lastNameController.text = data["lastName"];
          return Scaffold(
            appBar: AppBar(title: Text("Profile settings")),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                showLoadingDialog(context);
                Map<String, dynamic> newData = {
                  "firstName": firstNameController.text.trim(),
                  "lastName": lastNameController.text.trim(),
                };
                if (newPasswordController.text.trim().isNotEmpty) {
                  try {
                    if (newPasswordController.text.trim() ==
                        confirmPasswordController.text.trim()) {
                      await FirebaseAuth.instance.currentUser
                          ?.updatePassword(newPasswordController.text.trim());
                    } else {
                      throw Exception(
                          "New password and confirm password do not match");
                    }
                  } catch (e) {
                    showToast(e.toString());
                    if (mounted) {
                      Navigator.pop(context);
                    }
                    return;
                  }
                }
                await FirebaseFirestore.instance
                    .collection("user")
                    .doc(uid)
                    .update(newData);
                if (mounted) {
                  Navigator.pop(context);
                }
                showToast("Profile updated");
              },
              label: Text("Update profile"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New Password',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm New Password',
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text("Loading...")),
        );
      },
    );
  }
}
