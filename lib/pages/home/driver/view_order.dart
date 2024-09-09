import 'package:eexily/components/order.dart';
import 'package:flutter/material.dart';

class ViewDriverOrder extends StatefulWidget {
  final Order order;

  const ViewDriverOrder({
    super.key,
    required this.order,
  });

  @override
  State<ViewDriverOrder> createState() => _ViewDriverOrderState();
}

class _ViewDriverOrderState extends State<ViewDriverOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
