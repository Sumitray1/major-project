import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:major_project/Widgets/product_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPages extends StatefulWidget {
  const ProductPages({super.key});

  @override
  _ProductPagesState createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    final response = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/product/all?page=0&limit=100&vendorId=$vendorId',
      ),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['products'];
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      print('Failed to load products');
      throw Exception('Failed to load products');
    }
  }

  void _refetchProducts() {
    setState(() {
      _products = fetchProducts();
    });
  }

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
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refetchProducts),
        ],
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
          FutureBuilder<List<Product>>(
            future: _products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load products'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found'));
              } else {
                return GridView.count(
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 0.75,
                  physics: NeverScrollableScrollPhysics(),
                  children:
                      snapshot.data!.map((product) {
                        return SizedBox(
                          child: ProductCard(
                            name: product.name,
                            description: product.description,
                            price: product.price,
                            imageLink:
                                product.images.isNotEmpty
                                    ? product.images[0].path
                                    : '',
                          ),
                        );
                      }).toList(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOptionsDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Options',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text(
                  'Add Product',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/product-details');
                },
              ),
              ListTile(
                leading: Icon(Icons.category),
                title: Text(
                  'Add Categories',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categories');
                  // Navigate to add categories page or perform any action
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final String discount;
  final String profit;
  final String stocks;
  final String vendor;
  final String category;
  final bool unlimitedStocks;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.profit,
    required this.stocks,
    required this.vendor,
    required this.category,
    required this.unlimitedStocks,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['desc'],
      price: json['price'],
      discount: json['discount'],
      profit: json['profit'],
      stocks: json['stocks'],
      vendor: json['vendor'],
      category: json['category'],
      unlimitedStocks: json['unlimitedStocks'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      images:
          (json['images'] as List)
              .map((image) => ProductImage.fromJson(image))
              .toList(),
    );
  }
}

class ProductImage {
  final String id;
  final String name;
  final String type;
  final String path;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  ProductImage({
    required this.id,
    required this.name,
    required this.type,
    required this.path,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      path: json['path'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
