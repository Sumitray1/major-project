import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:major_project/pages/add_categories.dart';
import 'package:major_project/pages/dashboard_page.dart';
import 'package:major_project/pages/edit_shopdetails.dart';
import 'package:major_project/pages/get_started_page,dart.dart';
import 'package:major_project/pages/my_store_page.dart';
import 'package:major_project/pages/order_details_page.dart';
import 'package:major_project/pages/orders_pages.dart';
import 'package:major_project/pages/otp_page.dart';
import 'package:major_project/pages/product_details_page.dart';
import 'package:major_project/pages/product_pages.dart';
import 'package:major_project/pages/singup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary color
        primaryColor: Color(0xFF446785),

        // Define AppBar Theme
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Color(0xFF446785)),
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF446785),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            height: 1.40,
          ),
        ),
        //buttom navigation
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
        //define theme for input field
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: Color(0xFF767676),
          hintStyle: TextStyle(
            color: Color(0xFF767676),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        // Define Text Theme for different headings
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF446785),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            height: 1.40,
          ), // h1
          displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ), //for font size 16 px  // h2
          displaySmall: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1.23,
          ), //for bold text like item, date, customer Details etc
          labelSmall: TextStyle(
            color: Color(0xFF7C7A7A),
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.23,
          ), //for disc of display small
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black), // body text
          bodyMedium: TextStyle(
            color: Color(0xFF767676),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ), // for input text field
          titleSmall: TextStyle(
            color: Color(0xFF303030),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            letterSpacing: 1.56,
          ),
        ),
        dialogTheme: DialogTheme(backgroundColor: Colors.white),
        // Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
            backgroundColor: Color(0xFF446785),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 2.15,
            ),
          ),
        ),
      ),
      routes: {
        '/': (context) => SignupPage(),
        '/dashboard': (context) => HomeScreen(),
        '/categories': (context) => AddCategories(),
        '/product-page': (context) => ProductPages(),
        '/otp-page': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return OtpPage(email: email);
        },
        '/Get-started': (context) => GetStartedPage(),
        '/order-details': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String;
          return OrderDetailsPage(id: id);
        },

        '/mystore': (context) => MyStorePage(),
        '/edit-shop': (context) => EditShopPage(),
        '/product-details': (context) => ProductDetailsPage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _pages = [
    ProductPages(),
    AddCategories(),
    OrdersPages(),
    MyStorePage(),
  ];

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,

            borderRadius: BorderRadius.circular(31),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(3, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _selectedPage == 0 ? Colors.white : Colors.transparent,
                  foregroundColor:
                      _selectedPage == 0
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                  iconColor:
                      _selectedPage == 0
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPage = 0;
                  });
                },
                icon: Icon(Iconsax.shopping_bag5, size: 30),
                label:
                    _selectedPage == 0 ? Text('Products') : SizedBox.shrink(),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _selectedPage == 1 ? Colors.white : Colors.transparent,
                  foregroundColor:
                      _selectedPage == 1
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                  iconColor:
                      _selectedPage == 1
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPage = 1;
                  });
                },
                icon: Icon(Iconsax.category5, size: 30),
                label:
                    _selectedPage == 1 ? Text('Categories') : SizedBox.shrink(),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _selectedPage == 2 ? Colors.white : Colors.transparent,
                  foregroundColor:
                      _selectedPage == 2
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                  iconColor:
                      _selectedPage == 2
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPage = 2;
                  });
                },

                icon: Icon(Iconsax.shopping_cart5, size: 30),
                label: _selectedPage == 2 ? Text('Orders') : SizedBox.shrink(),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _selectedPage == 3 ? Colors.white : Colors.transparent,
                  foregroundColor:
                      _selectedPage == 3
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                  iconColor:
                      _selectedPage == 3
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPage = 3;
                  });
                },
                icon: Icon(Iconsax.shop5, size: 30),
                label: _selectedPage == 3 ? Text('Store') : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
