// ignore_for_file: require_trailing_commas, avoid_print, prefer_adjacent_string_concatenation, unused_local_variable, unnecessary_string_interpolations

import 'package:ecopoints/models/item.dart';
import 'package:ecopoints/pages/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  final Item item;
  const ItemPage({super.key, required this.item});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  void addToCart(item, quantity) {
    final store = context.read<Store>();
    final itemMenu = store.itemMenu;
    store.addToCart(item, quantity);
    for (int i = 0; i < itemMenu.length; i++) {
      if (itemMenu[i].name == item.name) {
        itemMenu[i].setQuantity(itemMenu[i].getQuantity() + 1);
      }
    }
  }

  void removeFromCart(item) {
    final store = context.read<Store>();
    store.removeFromCart(item);
    final itemMenu = store.itemMenu;
    for (int i = 0; i < itemMenu.length; i++) {
      if (itemMenu[i].name == item.name) {
        itemMenu[i].setQuantity(itemMenu[i].getQuantity() - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
        builder: (context, value, child) => Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            // leading: Center(
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     decoration: BoxDecoration(
                            //         image: DecorationImage(
                            //           fit: BoxFit.contain,
                            //           image: AssetImage('assets/bottle.png'),
                            //         ),
                            //         borderRadius: BorderRadius.circular(5)),
                            //   ),
                            // ),
                            // leading: Center(
                            //   child: Image.asset(
                            //     'assets/bottle.png',
                            //     width: 100,
                            //     height: 100,
                            //     fit: BoxFit.contain, // or desired fit option
                            //   ),
                            // ),
                            leading: Icon(Icons.apple),
                            title: Text(
                              "${widget.item.name}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "৳${widget.item.price} per KG.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                          ),
                          InkWell(
                              onTap: () {
                                int temp = widget.item.getQuantity();
                                if (temp > 0) {
                                  setState(() {
                                    removeFromCart(widget.item);
                                    temp--;
                                    widget.item.setQuantity(temp);
                                    // widget.it
                                  });
                                }
                              },
                              child: Container(
                                width: 30,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 75, 105, 76),
                                ),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 40,
                            child: Text(
                              "${widget.item.getQuantity()}",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              int temp = widget.item.getQuantity();
                              temp++;
                              addToCart(widget.item, 1);
                              setState(() {
                                widget.item.setQuantity(temp);
                              });
                            },
                            child: Container(
                              width: 30,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 75, 105, 76),
                              ),
                              child: Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ]),
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
                              // "$total",
                              //"৳$total",
                              "৳${(widget.item.getQuantity() * widget.item.price)}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ));
  }
}
