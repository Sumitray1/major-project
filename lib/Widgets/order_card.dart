import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String name;
  final String disc;
  final String orderStatus;
  final String qty;
  final String price;
  final String imageUrl; // Add imageUrl field

  const OrderCard({
    Key? key,
    required this.name,
    required this.disc,
    required this.orderStatus,
    required this.qty,
    required this.price,
    required this.imageUrl, // Add imageUrl to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(width: 16), // Add some spacing between image and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $name',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 14),
                Text(
                  'Customer: $disc',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 14),
                Text(
                  'QTY: $qty',
                  style: TextStyle(
                    color: Color(0xFF7C7A7A),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.23,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Status: $orderStatus',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 14),
                Text(
                  'Rs. $price',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
