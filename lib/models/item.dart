// ignore_for_file: unused_element, require_trailing_commas, unnecessary_this

class Item {
  String name;
  int price;
  String imagePath;
  int _quantity;

  Item(
      {required this.name,
      required this.price,
      required this.imagePath,
      int quantity = 0})
      : _quantity = quantity;

  Item copyWith({
    String? name,
    int? price,
    String? imagePath,
    int? quantity,
  }) {
    return Item(
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this._quantity,
    );
  }

  setQuantity(int quantity) {
    _quantity = quantity;
  }

  getQuantity() {
    return _quantity;
  }
}
