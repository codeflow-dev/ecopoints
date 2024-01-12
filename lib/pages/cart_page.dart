// cart_page.dart
// ignore_for_file: require_trailing_commas, unused_local_variable, unnecessary_string_interpolations, avoid_print, dead_code, avoid_function_literals_in_foreach_calls

import 'package:ecopoints/pages/agent_location.dart';
import 'package:ecopoints/pages/item_page.dart';
import 'package:ecopoints/pages/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = context.read<Store>().cart;
    double subTotal() {
      double total = 0;
      for (int i = 0; i < cart.length; i++) {
        total += (cart[i].price * cart[i].getQuantity());
      }
      return total;
    }

    return Consumer<Store>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 68, 158, 71),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => BuyerPage()));
            },
            icon: Icon(Icons.arrow_back_rounded),
          ),
          title: Text("MY CART"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text(
              "*Please swipe left to remove an item from the cart",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: value.cart.length,
              itemBuilder: (context, index) {
                final item = value.cart[index];
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      //
                      setState(() {
                        for (int i = 0; i < value.itemMenu.length; i++) {
                          if (value.itemMenu[i].name == item.name) {
                            value.itemMenu[i].setQuantity(0);
                          }
                        }
                        value.deleteFromCart(item);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('${item.name} is removed from the cart')),
                      );
                    },
                    background: Container(color: Colors.red),
                    child: ItemPage(item: item));
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          color: Color.fromARGB(255, 82, 152, 66),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 150,
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 54, 134, 61)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "৳${subTotal()}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AgentLocation()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
