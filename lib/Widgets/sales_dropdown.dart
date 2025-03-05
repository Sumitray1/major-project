import 'package:flutter/material.dart';

class SalesDropdown extends StatefulWidget {
  const SalesDropdown({super.key});

  @override
  State<SalesDropdown> createState() => _SalesDropdownState();
}

class _SalesDropdownState extends State<SalesDropdown> {
  String dropdownValue = 'This Week'; // Move it to the class level

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 130,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300), // Added border
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Color(0xFF716B6B),
          ),
          dropdownColor: Colors.white,
          elevation: 1,
          isExpanded: true,
          style: TextStyle(
            color: Color(0xFF716B6B),
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                dropdownValue = newValue;
              });
            }
          },
          items:
              ["This Week", "This Month", "Last Month", "This Year"]
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
