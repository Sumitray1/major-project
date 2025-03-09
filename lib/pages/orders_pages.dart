import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:major_project/Widgets/order_card.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPages extends StatefulWidget {
  const OrdersPages({super.key});

  @override
  _OrdersPagesState createState() => _OrdersPagesState();
}

class _OrdersPagesState extends State<OrdersPages> {
  late Future<List<Order>> _orders;
  String _selectedCategory = "All Orders";

  @override
  void initState() {
    super.initState();
    _orders = fetchOrders();
  }

  Future<List<Order>> fetchOrders({String? category}) async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    final SharedPreferencesService _prefsService = SharedPreferencesService();

    String? vendorId = sf.getString('vendorId');
    String? accessToken = await _prefsService.getToken();

    final response = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/bookings/all?page=0&limit=20&vendorId=$vendorId',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['bookings'];
      List<Order> orders =
          jsonResponse.map((order) => Order.fromJson(order)).toList();

      if (category != null && category != "All Orders") {
        orders =
            orders.where((order) => order.bookingStatus == category).toList();
      }

      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  void _refetchOrders({String? category}) {
    setState(() {
      _selectedCategory = category ?? "All Orders";
      _orders = fetchOrders(category: _selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "All Orders",
      "Pending",
      "Verified",
      "Accepted",
      "Shipping",
      "Delivered",
      "Refunded",
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refetchOrders(),
          ),
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
                    hintText: 'Search for orders',
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          FutureBuilder<List<Order>>(
            future: _orders,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load orders'));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.hasData ? snapshot.data!.length : 0} Orders Found',
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
                                  onPressed:
                                      () => _refetchOrders(category: category),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        _selectedCategory == category
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
                                          _selectedCategory == category
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
                    if (!snapshot.hasData || snapshot.data!.isEmpty)
                      Center(child: Text('No orders found')),
                    if (snapshot.hasData && snapshot.data!.isNotEmpty)
                      Column(
                        children:
                            snapshot.data!.map((order) {
                              return Column(
                                children: [
                                  SizedBox(height: 14),
                                  OrderCard(
                                    price: order.price,
                                    name: '${order.fname} ${order.lname}',
                                    orderStatus: order.bookingStatus,
                                    qty: order.qty,
                                    disc: order.product.desc,
                                    orderId: order.id,
                                    imageUrl:
                                        order.product.images.isNotEmpty
                                            ? order.product.images[0].path
                                            : '',
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                  ],
                );
              }
            },
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

class Order {
  final String id;
  final String fname;
  final String lname;
  final String bookingStatus;
  final String createdAt;
  final String address;
  final String phone;
  final String email;
  final Product product;
  final String vendor;
  final String price;
  final String discount;
  final String priceAfterDiscount;
  final String profit;
  final String qty;
  final String domain;
  final int otp;
  final String paymentStatus;
  final String paymentMethod;
  final bool isDeleted;

  Order({
    required this.id,
    required this.fname,
    required this.lname,
    required this.bookingStatus,
    required this.createdAt,
    required this.address,
    required this.phone,
    required this.email,
    required this.product,
    required this.vendor,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.profit,
    required this.qty,
    required this.domain,
    required this.otp,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.isDeleted,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      fname: json['fname'],
      lname: json['lname'],
      bookingStatus: json['bookingStatus'],
      createdAt: json['createdAt'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      product: Product.fromJson(json['product']),
      vendor: json['vendor'],
      price: json['price'],
      discount: json['discount'],
      priceAfterDiscount: json['priceAfterDiscount'],
      profit: json['profit'],
      qty: json['qty'],
      domain: json['domain'],
      otp: json['otp'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      isDeleted: json['isDeleted'],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String desc;
  final List<ProductImage> images;
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

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.images,
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
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['images'] as List;
    List<ProductImage> imagesList =
        list.map((i) => ProductImage.fromJson(i)).toList();

    return Product(
      id: json['_id'],
      name: json['name'],
      desc: json['desc'],
      images: imagesList,
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
