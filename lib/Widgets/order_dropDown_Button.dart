import 'package:flutter/material.dart';

class OrderDropdownButton extends StatefulWidget {
  const OrderDropdownButton({super.key});

  @override
  State<OrderDropdownButton> createState() => _OrderDropdownButtonState();
}

class _OrderDropdownButtonState extends State<OrderDropdownButton> {
  String dropdownValue = 'Pending';
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
        },
        items:
            <String>["Pending", "Processing", "Delivered", "Cancelled"].map((
              String value,
            ) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
      ),
    );
  }
}
