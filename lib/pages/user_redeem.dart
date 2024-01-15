import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/color_schemes.g.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/redeem_qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRedeemPage extends StatefulWidget {
  final int userPoints;

  const UserRedeemPage(this.userPoints, {super.key});

  @override
  State<UserRedeemPage> createState() => _UserRedeemPageState();
}

class _UserRedeemPageState extends State<UserRedeemPage> {
  final items = [
    RedeemItem("100Tk Cash", 100),
    RedeemItem("Premium Mug", 100),
    RedeemItem("T-shirt", 200),
  ];

  int totalPoints() {
    var total = 0;
    for (var item in items) {
      total += item.quantity * item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redeem Items"),
      ),
      body: ListView(
        children: [
          for (var item in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: Icon(Icons.apple),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${item.price} points/item",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Row(
                        children: [
                          RoundedCharButton("-", () {
                            if (item.quantity > 0) {
                              setState(
                                () {
                                  item.quantity--;
                                },
                              );
                            }
                          }),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 40,
                            child: Text(
                              "${item.quantity}",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 10),
                          RoundedCharButton("+", () {
                            setState(
                              () {
                                item.quantity++;
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 40,
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: Text(
                          "${item.price * item.quantity} points",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: SizedBox(height: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            child: Text(
              "Total              ${totalPoints()} points",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              "You have ${widget.userPoints} points",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (totalPoints() > widget.userPoints) {
            Fluttertoast.showToast(
              msg: "This is Center Short Toast",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: greenColor,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
          showLoadingDialog(context);
          await FirebaseFirestore.instance
              .collection("user")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"points": FieldValue.increment(-totalPoints())});
          Map<String, dynamic> data = {};
          for (var item in items) {
            data[item.name] = item.quantity;
          }
          data["received"] = false;
          final redeem =
              await FirebaseFirestore.instance.collection("redeem").add(data);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RedeemQRPage(redeem.id),
              ),
            );
          }
        },
        label: Text("Redeem"),
        icon: Icon(Icons.add_task_sharp),
      ),
    );
  }
}

class RedeemItem {
  final String name;
  final int price;
  int quantity;

  RedeemItem(this.name, this.price) : quantity = 0;
}

class RoundedCharButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const RoundedCharButton(this.text, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 30,
      width: 30,
      child: Material(
        color: Color.fromARGB(255, 75, 105, 76),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
