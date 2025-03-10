import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'package:major_project/services/shared_preferences_service.dart';

class CategoriesCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String id;

  const CategoriesCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.id,
  });

  @override
  _CategoriesCardState createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  bool _isDeleted = false;

  Future<void> deleteProduct() async {
    final SharedPreferencesService _prefsService = SharedPreferencesService();
    String? accessToken = await _prefsService.getToken();
    final String url =
        "https://sellsajilo-backend.onrender.com/v1/category/delete/id/${widget.id}";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isDeleted = true;
        });
        _showSnackBar(context, "Product deleted successfully", Colors.green);
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        _showSnackBar(
          context,
          "Failed to delete product: ${responseBody['message']}",
          Colors.red,
        );
      }
    } catch (e) {
      _showSnackBar(context, "Error: $e", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Container(
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
                    aspectRatio: 16 / 9,
                    child: Image.network(widget.imageUrl, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 14),
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 14),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 2,
            child: Material(
              color: Colors.white, // Background color
              elevation: 4.0, // Elevation
              shape: CircleBorder(), // Shape of the button
              child: IconButton(
                icon: Icon(Iconsax.trash, color: Colors.red),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: Colors.red),
          ),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProduct();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
