import 'package:flutter/material.dart';
import 'package:major_project/Widgets/categories_dropDown.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Details'),
            Text(
              'Add and  and manage your products.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 200,

            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Image.asset(
                  'assets/images/shoes2.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/images/shoes2.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/images/shoes2.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Text(
            "Please fill these details to add a Product",
            style: TextStyle(
              color: Color(0xFF7C7A7A),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.23,
            ),
          ),
          SizedBox(height: 14),
          Text('Product Name', style: Theme.of(context).textTheme.displaySmall),

          Text(
            'This product name will display to buyers',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Air Force 1 Jester XX Black Sonic Yellow',
            ),
          ),

          SizedBox(height: 20),
          Text(
            'Product Description',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'This product description will display to buyers',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Air Force 1 Jester XX Black Sonic Yellow',
            ),
            maxLines: 15,
            minLines: 10,
          ),

          SizedBox(height: 20),
          Text(
            'Product Price (Rs)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'This is the price for calculating your profit stats.',
            style: Theme.of(context).textTheme.titleSmall,
          ),

          SizedBox(height: 8),
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '4999'),
          ),

          SizedBox(height: 20),
          Text(
            'Crossed Price (Rs)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'It is the price to show user in crossed, raised price.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: '4999',
              hintStyle: TextStyle(
                color: Color(0xFF7C7A7A),

                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),

          SizedBox(height: 20),
          Text(
            'Selling Price (Rs)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'This is the actual price client will buy the product at.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '4999'),
          ),

          SizedBox(height: 20),
          Text('Categories', style: Theme.of(context).textTheme.displaySmall),

          Text(
            'Select all the categories this product belongs to.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),

          CategoriesDropdown(),
          SizedBox(height: 20),

          Text(
            'Sub-Categories',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'Select all the categories this product belongs to.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),

          CategoriesDropdown(),
          SizedBox(height: 20),

          Text('Stocks', style: Theme.of(context).textTheme.displaySmall),
          Text(
            'No of stocks(items) of this product available in your inventory.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '99'),
          ),

          SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text('Update Details')),
        ],
      ),
    );
  }
}
