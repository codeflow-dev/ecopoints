import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/pages/buyer_page.dart';
import 'package:ecopoints/pages/user_redeem.dart';
import 'package:ecopoints/pages/user_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  UserHomePage({super.key});

  final agent = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: agent,
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
            appBar: AppBar(title: Text("Welcome, ${data['firstName']}")),
            body: GridView.count(
              crossAxisCount: 2,
              children: [
                NavCard(
                  "Scan QR Code",
                  Icons.qr_code,
                  MaterialPageRoute(
                    builder: (context) => UserScanPage(),
                  ),
                ),
                NavCard(
                  "Redeem Points",
                  Icons.redeem,
                  MaterialPageRoute(
                    builder: (context) => UserRedeemPage(),
                  ),
                ),
                NavCard(
                  "Order Recyclables",
                  Icons.shopping_bag,
                  MaterialPageRoute(
                    builder: (context) => BuyerPage(),
                  ),
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
  final Route route;
  final String text;
  final IconData icon;

  const NavCard(
    this.text,
    this.icon,
    this.route, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            route,
          );
        },
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
