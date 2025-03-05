import 'package:flutter/material.dart';
import 'package:major_project/Widgets/order_card.dart';

class OrdersPages extends StatelessWidget {
  const OrdersPages({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "All Orders",
      "Pending",
      "Accepted",
      "Shipping",
      "Verifying",
      "Canceled",
    ];
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orders'),
            Text(
              'View and manage your orders.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search for products',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: Color(0xFF767676),
                  size: 35,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Border radius
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            '25 Products Found',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor:
                              category == "All Orders"
                                  ? Colors.black
                                  : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          category,
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(
                            color:
                                category == "All Orders"
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          SizedBox(height: 14),

          ...List.generate(
            5,
            (index) => Column(children: [SizedBox(height: 14), OrderCard()]),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
