import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:major_project/Widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPages extends StatefulWidget {
  const ProductPages({super.key});

  @override
  _ProductPagesState createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  late Future<Map<String, dynamic>> _data;
  String _selectedCategoryId = 'All';

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>> fetchData([String? categoryId]) async {
    final categories = await fetchCategories();
    final products = await fetchProducts(categoryId);
    return {'categories': categories, 'products': products};
  }

  Future<List<Product>> fetchProducts([String? categoryId]) async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    String searchText = _searchController.text.trim();
    String url =
        'https://sellsajilo-backend.onrender.com/v1/product/all?page=0&limit=30&vendorId=$vendorId';
    if (searchText.isNotEmpty) {
      url += '&search=$searchText';
    }
    if (categoryId != null && categoryId != 'All') {
      url += '&categoryId=$categoryId';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['products'];
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    final response = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/category/all/${vendorId}',
      ),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['categories'];
      List<Category> categories =
          jsonResponse.map((category) => Category.fromJson(category)).toList();
      categories.insert(
        0,
        Category(id: 'All', name: 'All Categories'),
      ); // Add "All Categories" option
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void _refetchProducts([String? categoryId]) {
    setState(() {
      _data = fetchData(categoryId);
    });
  }

  void _removeProduct(String id) {
    setState(() {
      _data = _data.then((data) {
        final products = data['products'] as List<Product>;
        products.removeWhere((product) => product.id == id);
        return data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () async {
          _refetchProducts(_selectedCategoryId);
        },
        child: FutureBuilder<List<Category>>(
          future: fetchCategories(),
          builder: (context, categorySnapshot) {
            if (categorySnapshot.hasError) {
              return Center(child: Text('Failed to load categories'));
            }

            final categories = categorySnapshot.data ?? [];

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search for products name',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          _refetchProducts(_selectedCategoryId);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                // Categories list
                if (categories.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedCategoryId = category.id;
                                  });
                                  _refetchProducts(category.id);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      category.id == _selectedCategoryId
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
                                  category.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall?.copyWith(
                                    color:
                                        category.id == _selectedCategoryId
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
                // Products grid with its own FutureBuilder
                FutureBuilder<List<Product>>(
                  future: fetchProducts(_selectedCategoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Failed to load products'));
                    }

                    final products = snapshot.data ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${products.length} Products Found',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 14),
                        GridView.count(
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 0.75,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                              products.map((product) {
                                return ProductCard(
                                  name: product.name,
                                  id: product.id,
                                  description: product.description,
                                  price: product.price,
                                  imageLink:
                                      product.images.isNotEmpty
                                          ? product.images[0].path
                                          : '',
                                  onDelete: () => _removeProduct(product.id),
                                  onProductDeleted:
                                      () =>
                                          _refetchProducts(_selectedCategoryId),
                                );
                              }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
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
    _data.then((data) {
      final categories = data['categories'] as List<Category>;
      if (categories.length <= 1) {
        // Only "All Categories" is present
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Add Category',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              content: Text(
                'Please add a category first to add a product.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Add Category',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/categories').then((_) {
                      _refetchProducts(_selectedCategoryId);
                    });
                  },
                ),
              ],
            );
          },
        );
      } else {
        Navigator.pushNamed(context, '/product-details').then((_) {
          _refetchProducts(_selectedCategoryId);
        });
      }
    });
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['_id'], name: json['name']);
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
