import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CategoriesCard({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Set a fixed height for all cards
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio:
                    16 / 9, // Maintain a 16:9 aspect ratio for the image
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              SizedBox(height: 14),
              Text(name, style: Theme.of(context).textTheme.displaySmall),
              SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}
