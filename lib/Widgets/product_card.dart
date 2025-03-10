import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:major_project/services/shared_preferences_service.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String description;
  final String price;
  final String imageLink;
  final String id;
  final VoidCallback onDelete;
  final VoidCallback onProductDeleted;

  const ProductCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageLink,
    required this.id,
    required this.onDelete,
    required this.onProductDeleted,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Future<void> deleteProduct(BuildContext context) async {
    SharedPreferencesService sf = SharedPreferencesService();
    String? accessToken = await sf.getToken();
    final url =
        'https://sellsajilo-backend.onrender.com/v1/product/delete/id/${widget.id}';

    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
      widget.onDelete();
      widget.onProductDeleted(); // Call the callback function
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageHeight =
            constraints.maxWidth *
            0.5; // Adjust the image height based on the width

        return Stack(
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
                    Image.network(
                      widget.imageLink,
                      height: imageHeight,
                      width:
                          constraints
                              .maxWidth, // Make the image take the full width
                      fit:
                          BoxFit
                              .cover, // Cover the full width while maintaining aspect ratio
                    ),
                    SizedBox(height: 14),
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: 14),
                    Text(
                      widget.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis, // Use ellipsis when text overflows
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 14),
                    Text(
                      widget.price,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.white,
                elevation: 4,
                shape: CircleBorder(),
                child: IconButton(
                  icon: Icon(Iconsax.trash),
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Confirm Delete',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(color: Colors.red),
                          ),
                          content: Text(
                            'Are you sure you want to delete this item?',
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Delete',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: Colors.red),
                              ),
                              onPressed: () {
                                deleteProduct(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
