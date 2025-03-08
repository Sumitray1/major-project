import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:major_project/classes/Configuration_Class.dart';
import 'package:major_project/classes/vendor_modal.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyStorePage extends StatefulWidget {
  MyStorePage({super.key});

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  final List<ConfigurationClass> configurationsList = [
    ConfigurationClass(
      imagePath: 'assets/images/domin.png',
      name: "Link a Custom Domain",
    ),
    ConfigurationClass(
      imagePath: 'assets/images/esawa.png',
      name: "Esewa Configurations",
    ),
    ConfigurationClass(
      imagePath: 'assets/images/khalti.png',
      name: "Khalti Configurations",
    ),
    ConfigurationClass(imagePath: '', name: "Allow Cash on Delivery"),
    ConfigurationClass(
      imagePath: 'assets/images/apperance.png',
      name: "Appearance",
    ),
    ConfigurationClass(
      imagePath: 'assets/images/visitweb.png',
      name: "Visit Website",
    ),
  ];
  late Future<VendorData> _vendorData;

  @override
  void initState() {
    super.initState();
    _vendorData = fetchVendorData();
  }

  Future<VendorData> fetchVendorData() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    final SharedPreferencesService _prefsService = SharedPreferencesService();
    String? accessToken = await _prefsService.getToken();
    String? vendorId = sf.getString('vendorId');

    final response = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/vendors/get-vendor/$vendorId',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print(response.body.toString());
    if (response.statusCode == 200) {
      return VendorData.fromJson(json.decode(response.body));
    } else {
      print(response.body.toString());
      throw Exception('Failed to load vendor details');
    }
  }

  Future<void> _refreshVendorData() async {
    setState(() {
      _vendorData = fetchVendorData();
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
            Text('My Store'),
            Text(
              'View and manage your store details.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVendorData,
        child: FutureBuilder<VendorData>(
          future: _vendorData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final vendorData = snapshot.data!;
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 14),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    height: 140,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 77,
                          height: 73,
                          child: Image.network(vendorData.logo.path),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendorData.shopName,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              vendorData.domains.isNotEmpty
                                  ? vendorData.domains[0]
                                  : '',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Text(
                              vendorData.phone,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Configurations',
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.69,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: configurationsList.length,
                    itemBuilder: (context, index) {
                      final item = configurationsList[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              item.imagePath.isEmpty
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                          children: <Widget>[
                            if (item.imagePath.isNotEmpty) ...[
                              Image.asset(
                                item.imagePath,
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(width: 16),
                            ],
                            Text(item.name),
                            if (item.imagePath.isEmpty)
                              Switch(value: true, onChanged: null),
                          ],
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences sf =
                          await SharedPreferences.getInstance();
                      sf.clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (_) => false,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logout.png',
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(width: 16),
                          Text('Logout'),
                        ],
                      ),
                    ),
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
