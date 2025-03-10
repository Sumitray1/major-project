import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:major_project/classes/vendor_modal.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyStorePage extends StatefulWidget {
  MyStorePage({super.key});

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
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
        'https://sellsajilo-backend.onrender.com/v1/vendors/get-vendor/id/$vendorId',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print(vendorId);
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

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF' + hex; // Add alpha value if missing
    }
    return Color(int.parse(hex, radix: 16));
  }

  void _pickColor(String currentColorHex, VendorData vendorData) {
    Color currentColor = hexToColor(currentColorHex);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                setState(() {
                  vendorData.brandColor = color.value.toRadixString(16);
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Update color'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    child: Stack(
                      children: [
                        Row(
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
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
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
                        Positioned(
                          top: -3,
                          right: -3,
                          child: Material(
                            color: Colors.white,
                            elevation: 2,
                            shape: CircleBorder(),
                            child: IconButton(
                              icon: Icon(Iconsax.edit),
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit-shop');
                              },
                            ),
                          ),
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/domin.png',
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Link a Custom Domain'),
                                SizedBox(height: 8),
                                if (vendorData.domains.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        vendorData.domains.map((domain) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4.0,
                                            ),
                                            child: Text(
                                              domain,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall?.copyWith(
                                                color: const Color.fromARGB(
                                                  255,
                                                  30,
                                                  117,
                                                  189,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: -15,
                          right: -15,
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit-shop');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/khalti.png',
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(width: 16),
                                Text('Khalti Configurations'),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(vendorData.khaltiKey!),
                          ],
                        ),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: IconButton(
                            icon: Icon(Iconsax.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit-shop');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 16),
                        Text('Allow Cash on Delivery'),
                        Spacer(),
                        Switch(
                          activeColor: Colors.green,
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/apperance.png',
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(width: 16),
                        Text('Appearance'),
                        Spacer(),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushNamed(context, '/edit-shop'),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: hexToColor(vendorData.brandColor),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (vendorData.domains.isNotEmpty) {
                          String domain = vendorData.domains[0];
                          if (!domain.startsWith('http://') &&
                              !domain.startsWith('https://')) {
                            domain = 'https://$domain';
                          }
                          final Uri url = Uri.parse(domain);
                          try {
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          } catch (e) {
                            print('Error: $e');
                            // Handle the error accordingly
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/visitweb.png',
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(width: 16),
                          Text('Visit Website'),
                        ],
                      ),
                    ),
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
