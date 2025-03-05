import 'package:flutter/material.dart';
import 'package:major_project/Widgets/order_dropdown_Button.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Details'),
            Text(
              '#asy134HGyausrihfhasdfasdgUAs',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 14),
          Container(
            height: 212,
            decoration: ShapeDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Image.asset(
              'assets/images/shoes11.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(height: 24),
          Text("item", style: Theme.of(context).textTheme.displaySmall),
          Text(
            "Nike \nRun Star Hike Three color Unisex",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 14),
          Text("Date", style: Theme.of(context).textTheme.displaySmall),
          Text(
            "Jan 24, 2024 8:30 PM",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 14),
          Text(
            "Customer Details",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            "Samir Khanal\nDhangadhi-18-Kailali\nFulwari (near Fulbari Academy)\n9804681405\nsamirkhanalofficial@gmail.com",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 14),
          Text(
            "Company Details",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            "Sassy Baneshwor\nBaneshwor\n9800000001",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 14),
          Text(
            "QTY:5",
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.right,
          ),
          Text(
            "5 x Rs. 960\nDelivery    Rs. 240\n9800000001",
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.right,
          ),
          Text(
            "unpaid (COD)       -        Rs. 2160",
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 14),
          Text("Order Status", style: Theme.of(context).textTheme.displaySmall),
          SizedBox(height: 14),
          OrderDropdownButton(),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.phone_in_talk_outlined, size: 28),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Update Status"),
                  style: ElevatedButton.styleFrom(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
