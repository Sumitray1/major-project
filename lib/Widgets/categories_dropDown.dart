import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CategoriesDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const CategoriesDropdown({super.key, required this.onChanged});

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  late String dropdownValue;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    final response = await http.get(
      Uri.parse(
        'https://sellsajilo-backend.onrender.com/v1/category/all/${vendorId}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories =
            (data['categories'] as List)
                .map(
                  (category) => {
                    'id': category['_id'],
                    'name': category['name'],
                  },
                )
                .toList();
        if (categories.isNotEmpty) {
          dropdownValue = categories[0]['name']!;
          widget.onChanged(categories[0]['id']!);
        }
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Color(0xFF716B6B),
        ),
        dropdownColor: Colors.white,
        elevation: 0,
        isExpanded: true,
        underline: SizedBox.shrink(),
        style: TextStyle(
          color: Color(0xFF716B6B),
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 1.87,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          final selectedCategory = categories.firstWhere(
            (category) => category['name'] == newValue,
          );
          widget.onChanged(selectedCategory['id']!);
        },
        items:
            categories.map<DropdownMenuItem<String>>((category) {
              return DropdownMenuItem<String>(
                value: category['name'],
                child: Text(category['name']!),
              );
            }).toList(),
      ),
    );
  }
}
