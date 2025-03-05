import 'package:flutter/material.dart';
import 'package:major_project/classes/Configuration_Class.dart';

class MyStorePage extends StatelessWidget {
  MyStorePage({super.key});
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
    ConfigurationClass(imagePath: 'assets/images/logout.png', name: "Logout"),
  ];
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

      body: ListView(
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
                  child: Image.asset('assets/images/logo.png'),
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sassy Baneshwor',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text(
                      'sassybaneshwor.com',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '9800000001',
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
                      Image.asset(item.imagePath, height: 25, width: 25),
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
        ],
      ),
    );
  }
}
