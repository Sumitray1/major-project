import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class GetSartedpage extends StatelessWidget {
  const GetSartedpage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(children: [
        Image.asset(
          "assets/back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        ListView(children: [
          SizedBox(
            height: 600,
            child: Image.asset("assets/company.png"),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Lets ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Color(0xFF3F6784),
                    ),
                    children: [
                      TextSpan(
                        text: 'Start',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' by',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Knowing Your ',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Business',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F6784),
                        ),
                      ),
                      TextSpan(
                        text: ' Info',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  "Provide us Your logo & store name",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Center(child: Image.asset("assets/logo.png")),
                  ),
                ),
                SizedBox(height: 20),
                buildTextField(
                  context,
                  icon: Iconsax.shop_remove5,
                  hintText: "eg. Sassy Baneshwor",
                  label: "Store Name",
                ),
                buildTextField(
                  context,
                  icon: Iconsax.location5,
                  hintText: "Choose on Map",
                  label: "Location",
                ),
                buildTextField(
                  context,
                  icon: Iconsax.location5,
                  hintText: "Full Address",
                  label: "Full Address",
                ),
                buildTextField(
                  context,
                  icon: Iconsax.global5,
                  hintText: "sassybaneshwor",
                  label: "Sub Domain",
                  suffixIcon: Icons.check_circle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "https://sassybaneshwor.nebulasansar.com",
                    style: TextStyle(
                        color: Color(0xFF726C6C),
                        fontFamily: "Poppins",
                        fontSize: 12),
                  ),
                ),
                buildTextField(
                  context,
                  icon: Icons.color_lens,
                  hintText: "#ABYSHA",
                  label: "Brand Color",
                  suffixWidget: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 54,
                  width: 338,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3F6784),
                      foregroundColor: Colors.white,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width - 40, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Update",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: "Poppins"),
                    ),
                  ),
                ),
              ],
            ),
          )
        ])
      ]));
}

Widget buildTextField(BuildContext context,
    {required IconData icon,
    required String hintText,
    required String label,
    IconData? suffixIcon,
    Widget? suffixWidget}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            fontSize: 12,
            color: Color(0xFF464646),
          ),
        ),
        SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Color(0xFF446785)),
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Color(0xFF726C6C),
                  fontFamily: "Poppins",
                  fontSize: 15),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: Color(0xFF2CF440))
                  : suffixWidget,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
