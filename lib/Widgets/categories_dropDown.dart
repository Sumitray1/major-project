import 'package:flutter/material.dart';

class CategoriesDropdown extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const CategoriesDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
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
          widget.onChanged(newValue!);
        },
        items:
            <String>["Men", "Women", "Unisex", "Kids", "Teens"].map((
              String value,
            ) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
      ),
    );
  }
}
