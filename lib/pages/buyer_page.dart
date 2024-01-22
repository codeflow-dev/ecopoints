// ignore_for_file: require_trailing_commas, unused_local_variable, avoid_print

import 'package:ecopoints/pages/cart_page.dart';
import 'package:ecopoints/pages/item_page.dart';
import 'package:ecopoints/pages/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyerPage extends StatefulWidget {
  const BuyerPage({super.key});

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  @override
  Widget build(BuildContext context) {
    final store = context.read<Store>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 68, 158, 71),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Order Now"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 8),
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: store.fetchAndSetItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error fetching items: ${snapshot.error}");
          } else {
            return store.itemMenu.isEmpty
                ? Center(child: Text("No items available"))
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: Column(
                              children: List.generate(
                                store.itemMenu.length,
                                (index) =>
                                    ItemPage(item: store.itemMenu[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        label: Text("Place Order"),
        icon: Icon(Icons.add_task_sharp),
      ),
    );
  }
}
