import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_flutter/models/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.order.total.toString(),
            ),
            subtitle: Text(
              DateFormat("dd MM yyyy hh:mm").format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                children: widget.order.products.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.title),
                      Text(
                          "${product.quantity}x  \$${product.quantity * product.price} "),
                    ],
                  );
                }).toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
