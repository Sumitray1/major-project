import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:major_project/Widgets/order_dropdown_Button.dart';
import 'package:major_project/classes/order_details.dart';
import 'package:major_project/classes/product_modal.dart';
import 'package:intl/intl.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatefulWidget {
  final String id;
  const OrderDetailsPage({super.key, required this.id});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Future<CombinedData> _combinedData;
  bool _isLoading = false;

  String updatedStatusValue = '';

  @override
  void initState() {
    super.initState();
    _combinedData = fetchCombinedData();
  }

  Future<CombinedData> fetchCombinedData() async {
    final SharedPreferencesService _prefsService = SharedPreferencesService();
    String? accessToken = await _prefsService.getToken();
    print('Access Token: $accessToken');

    final orderResponse = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/bookings/id/${widget.id}',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (orderResponse.statusCode != 200) {
      throw Exception('Failed to load order details');
    }

    final orderData = OrderDetailsData.fromJson(
      json.decode(orderResponse.body),
    );

    print('Order Data: ${orderData.toString()}');

    final productResponse = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/product/id/${orderData.product}',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (productResponse.statusCode != 200) {
      throw Exception('Failed to load product details');
    }

    final productData = ProductData.fromJson(json.decode(productResponse.body));

    return CombinedData(orderData: orderData, productData: productData);
  }

  Future<void> _refreshCombinedData() async {
    setState(() {
      _combinedData = fetchCombinedData();
    });
  }

  // for updating Status
  Future<void> updateBookingStatus(String status) async {
    setState(() {
      _isLoading = true;
    });

    final SharedPreferencesService _prefsService = SharedPreferencesService();
    String? accessToken = await _prefsService.getToken();
    print('Access Token: $accessToken');

    final response = await http.put(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/bookings/update/id/${widget.id}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'bookingStatus': status}),
    );
    print(response.body.toString());
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update Order status')));

      throw Exception('Failed to update Order status');
    }
  }
  // make phone call

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      print('Error occurred: $e');
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
            Text('Order Details'),
            Text(widget.id, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCombinedData,
        child: FutureBuilder<CombinedData>(
          future: _combinedData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final combinedData = snapshot.data!;
              final orderData = combinedData.orderData;
              final productData = combinedData.productData;

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 14),
                  Container(
                    height: 212,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Image.network(
                      productData.images[0].path,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Product Name",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    productData.name,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: 14),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    productData.desc,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: 14),
                  Text("Date", style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    DateFormat("MMM d, y h:mm a").format(orderData.createdAt),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),

                  SizedBox(height: 14),
                  Text(
                    "Customer Details",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    '${orderData.fname} ${orderData.lname}\n${orderData.address}\n${orderData.phone}\n${orderData.email}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: 14),
                  Text(
                    "Customer Details",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    DateFormat("MMM d, y h:mm a").format(orderData.createdAt),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    "QTY:${orderData.qty}",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    "${orderData.qty} x Rs. ${orderData.priceAfterDiscount}\nDelivery    Rs. 50",
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    "${orderData.paymentStatus} (${orderData.paymentMethod})       -        Rs. ${int.parse(orderData.qty) * int.parse(orderData.priceAfterDiscount) + 50}",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 14),
                  Text(
                    "Order Status",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 14),

                  OrderDropdownButton(
                    onChanged: (String newStatus) {
                      setState(() {
                        updatedStatusValue = newStatus;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          makePhoneCall(orderData.phone);
                        },
                        icon: Icon(Icons.phone_in_talk_outlined, size: 28),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              updatedStatusValue == ''
                                  ? null
                                  : _isLoading
                                  ? null
                                  : () {
                                    updateBookingStatus(updatedStatusValue);
                                  },

                          style: ElevatedButton.styleFrom(),
                          child:
                              _isLoading
                                  ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                  : Text("Update Status"),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class CombinedData {
  final OrderDetailsData orderData;
  final ProductData productData;

  CombinedData({required this.orderData, required this.productData});
}
