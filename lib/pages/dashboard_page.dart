import 'package:flutter/material.dart';
import 'package:major_project/Widgets/bar_Chart_Sales.dart';
import 'package:major_project/Widgets/sales_dropdown.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard'),
            Text(
              'View and manage your store.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sales Report',
                      style: TextStyle(
                        color: Color(0xFF22005B),
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SalesDropdown(),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(height: 200, child: BarChartSales()),
              ],
            ),
          ),
          SizedBox(height: 80),
          Container(
            padding: EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Expires on : 2024-12-31',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 2),
                Text(
                  'Basic Plan - Rs. 2000',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(minimumSize: Size(80, 40)),
                    child: Text('Renew'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
