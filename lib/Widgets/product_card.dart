import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageLink;

  const ProductCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageHeight =
            constraints.maxWidth *
            0.5; // Adjust the image height based on the width

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageLink,
                  height: imageHeight,
                  width:
                      constraints
                          .maxWidth, // Make the image take the full width
                  fit:
                      BoxFit
                          .cover, // Cover the full width while maintaining aspect ratio
                ),
                SizedBox(height: 14),
                Text(name, style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: 14),
                Text(
                  description,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis, // Use ellipsis when text overflows
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 14),
                Text(price, style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
          ),
        );
      },
    );
  }
}
