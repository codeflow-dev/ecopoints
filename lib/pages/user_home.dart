import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/pages/buyer_page.dart';
import 'package:ecopoints/pages/user_details.dart';
import 'package:ecopoints/pages/user_redeem.dart';
import 'package:ecopoints/pages/user_scan.dart';
import 'package:ecopoints/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  Future getUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    var user =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();
    if (!user.exists) {
      final agent =
          (await FirebaseFirestore.instance.collection("agent").doc(uid).get())
              .data()!;
      await FirebaseFirestore.instance.collection("user").doc(uid).set(
        {
          "firstName": agent["firstName"],
          "lastName": agent["lastName"],
          "points": 0,
        },
        SetOptions(merge: true),
      );
      user = await FirebaseFirestore.instance.collection("user").doc(uid).get();
    }
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
          return Scaffold(
            appBar: AppBar(
              title: Text("Welcome, ${data['firstName']}"),
              leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomePage()));
                },
              ),
              actions: [
                Row(
                  children: [
                    Icon(Icons.account_balance),
                    SizedBox(width: 5),
                    Text(data["points"].toString()),
                    SizedBox(width: 15),
                  ],
                ),
              ],
            ),
            body: GridView.count(
              crossAxisCount: 2,
              children: [
                NavCard(
                  "Scan QR Code",
                  Icons.qr_code,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScanPage(),
                      ),
                    );
                  },
                ),
                NavCard(
                  "Redeem Points",
                  Icons.redeem,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserRedeemPage(data['points'] ?? 0),
                      ),
                    );
                  },
                ),
                NavCard(
                  "Order Recyclables",
                  Icons.shopping_bag,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyerPage(),
                      ),
                    );
                  },
                ),
                NavCard(
                  "Update Profile",
                  Icons.person,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(),
                      ),
                    );
                  },
                ),
              ],
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

class NavCard extends StatelessWidget {
  final Function() onTap;
  final String text;
  final IconData icon;

  const NavCard(
    this.text,
    this.icon,
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40),
                SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
