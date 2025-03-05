import 'package:flutter/material.dart';
import 'package:major_project/pages/my_store_page.dart';
import 'package:major_project/pages/order_details_page.dart';
import 'package:major_project/pages/orders_pages.dart';
import 'package:major_project/pages/product_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary color
        primaryColor: Color(0xFF446785),

        // Define AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: WidgetStateColor.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF446785),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            height: 1.40,
          ),
        ),
        //define theme for input filed
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
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
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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

        // Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
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
      home: OrdersPages(),
      routes: {
        '/orders-details': (context) => OrderDetailsPage(),
        '/mystore': (context) => MyStorePage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _pages = [MyStorePage(), OrderDetailsPage()];

  int _selectedPage = 0;
  void _changePage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: ShapeDecoration(
            color: Color(0xFF446785),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Store'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
            onTap: _changePage,
            currentIndex: _selectedPage,
            backgroundColor: WidgetStateColor.transparent,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
