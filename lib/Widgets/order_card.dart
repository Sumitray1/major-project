import 'package:flutter/material.dart';
import 'package:major_project/pages/order_details_page.dart';

class OrderCard extends StatelessWidget {
  final String name;
  final String disc;
  final String orderStatus;
  final String qty;
  final String price;
  final String imageUrl;
  final String orderId; // Add orderId field

  const OrderCard({
    Key? key,
    required this.name,
    required this.disc,
    required this.orderStatus,
    required this.qty,
    required this.price,
    required this.imageUrl,
    required this.orderId, // Add orderId to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'accepted':
          return Color(0x1F43F633); // Accepted with opacity 20%
        case 'verified':
          return Color.fromARGB(71, 47, 102, 206); // Verified with opacity 20%
        case 'shipping':
          return Color.fromARGB(197, 220, 233, 43); // Shipping with opacity 20%
        case 'delivered':
          return Color.fromARGB(80, 46, 196, 78); // Delivered with opacity 20%
        case 'cancelled':
          return Color.fromARGB(235, 231, 64, 34); // Cancelled with opacity 20%
        default:
          return Colors.white; // Pending or any other status
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(id: orderId),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16), // Add some spacing between image and text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        '$name',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(height: 6),
                      Text(
                        '$disc',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 6),
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
                      SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Rs. $price',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0, // Adjust top value to ensure it is not cropped
            left: 40,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(orderStatus),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                orderStatus,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
