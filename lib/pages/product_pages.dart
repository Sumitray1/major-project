import 'package:flutter/material.dart';
import 'package:major_project/Widgets/product_Card.dart';

class ProductPages extends StatelessWidget {
  const ProductPages({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "All Category",
      "Electronics",
      "Clothing",
      "Home & Kitchen",
      "Beauty",
      "Books",
      "Sports",
    ];
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products'),
            Text(
              'View and manage your stocks.',
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
                              category == 'All Category'
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
                                category == 'All Category'
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
          GridView.count(
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,

            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 0.75,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(16, (index) {
              return SizedBox(child: ProductCard());
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/product-details');
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
