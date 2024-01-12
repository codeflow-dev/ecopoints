// ignore_for_file: require_trailing_commas, unused_field, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/models/item.dart';
import 'package:flutter/material.dart';

class Store extends ChangeNotifier {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection("item");
  Future<List<Item>> fetchItems() async {
    try {
      QuerySnapshot querySnapshot = await itemsCollection.get();
      List<Item> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Item(
          name: data['name'] ?? "",
          price: data['sellingPrice'] ?? 0,
          imagePath: data['imagePath'] ?? "",
        );
      }).toList();
      return items;
    } on Exception catch (e) {
      print("item fetching failed: $e");
      return [];
    }
  }

  Future<void> fetchAndSetItems() async {
    try {
      List<Item> fetchedItems = await fetchItems();
      _itemMenu.clear();
      _itemMenu.addAll(fetchedItems);
      notifyListeners();
    } catch (e) {
      print("fetchAndSetItems failed: $e");
    }
  }

  final List<Item> _itemMenu = [];
  // final List<Item> _itemMenu = [
  //   Item(name: "Plastic", price: 40, imagePath: ""),
  //   Item(name: "Paper", price: 34, imagePath: ""),
  //   Item(name: "Bottle", price: 34, imagePath: ""),
  // ];

  List<Item> _cart = [];
  List<Item> get itemMenu => _itemMenu;
  List<Item> get cart => _cart;
  //adding one
  void addToCart(Item item, int quantity) {
    var existingItemIndex =
        _cart.indexWhere((cartItem) => cartItem.name == item.name);
    // var itemIndex =
    _cart.indexWhere((cartItem) => cartItem.name == item.name);

    if (existingItemIndex != -1) {
      _cart[existingItemIndex]
          .setQuantity(_cart[existingItemIndex].getQuantity() + quantity);
    } else {
      _cart.add(item.copyWith(quantity: quantity));
    }
    notifyListeners();
  }

  //removing all
  void deleteFromCart(Item item) {
    _cart.remove(item);
    notifyListeners();
  }

  //removing one
  void removeFromCart(Item item) {
    var existingItemIndex =
        _cart.indexWhere((cartItem) => cartItem.name == item.name);

    if (existingItemIndex != -1) {
      int temp = _cart[existingItemIndex].getQuantity();
      temp--;

      _cart[existingItemIndex].setQuantity(temp);

      if (temp == 0) {
        _cart.removeAt(existingItemIndex);
      }
    }
    notifyListeners();
  }

  Store() {
    fetchAndSetItems();
  }
}
