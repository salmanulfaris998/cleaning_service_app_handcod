import 'package:collection/collection.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  CartItem copyWith({String? id, String? name, double? price, int? quantity}) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  bool get isEmpty => items.isEmpty;
  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.total);

  CartItem? itemById(String id) =>
      items.firstWhereOrNull((element) => element.id == id);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class BillItem {
  final String label;
  final double amount;
  final bool isDiscount;

  const BillItem({
    required this.label,
    required this.amount,
    this.isDiscount = false,
  });
}

class CartSummary {
  final CartState state;
  final double serviceFee;

  CartSummary({
    required this.state,
    required this.serviceFee,
  });

  double get total => state.subtotal + serviceFee;

  List<BillItem> buildBillItems({
    required String subtotalLabel,
    required String serviceFeeLabel,
    String couponLabel = 'Coupon Discount',
    double couponDiscount = 0.0,
  }) {
    final items = <BillItem>[
      BillItem(label: subtotalLabel, amount: state.subtotal),
    ];

    if (couponDiscount > 0) {
      items.add(
        BillItem(
          label: couponLabel,
          amount: couponDiscount,
          isDiscount: true,
        ),
      );
    }

    if (serviceFee > 0) {
      items.add(BillItem(label: serviceFeeLabel, amount: serviceFee));
    }

    return items;
  }
}
