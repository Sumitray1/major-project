import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:major_project/Widgets/categories_dropdown.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _crossedPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _stocksController = TextEditingController();

  Future<void> _updateProductDetails() async {
    final String apiUrl = 'https://yourapiurl.com/updateProduct';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'productName': _productNameController.text,
        'productDescription': _productDescriptionController.text,
        'productPrice': _productPriceController.text,
        'crossedPrice': _crossedPriceController.text,
        'sellingPrice': _sellingPriceController.text,
        'stocks': _stocksController.text,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product details updated successfully')),
      );
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product details')),
      );
    }
  }

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
              'Add and manage your products.',
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
            controller: _productNameController,
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
            controller: _productDescriptionController,
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
            controller: _productPriceController,
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
            controller: _crossedPriceController,
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
            controller: _sellingPriceController,
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
            controller: _stocksController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '99'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateProductDetails,
            child: Text('Update Details'),
          ),
        ],
      ),
    );
  }
}
