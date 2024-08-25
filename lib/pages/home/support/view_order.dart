import 'package:eexily/components/order.dart';
import 'package:flutter/material.dart';


class ViewOrder extends StatefulWidget {
  final Order order;
  const ViewOrder({super.key, required this.order,});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
