import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            Image.asset('assets/images/shoes1.png', fit: BoxFit.fitHeight),
            SizedBox(height: 14),
            Text('Nike', style: Theme.of(context).textTheme.displaySmall),
            SizedBox(height: 14),
            Text(
              'Air Jordan 1 Retro High Obsidian UNC ',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 14),
            Text('Rs. 966', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
