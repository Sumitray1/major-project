import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:major_project/Widgets/categories_dropdown.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _profitController = TextEditingController();
  final TextEditingController _stocksController = TextEditingController();
  List<File> _images = [];

  bool _unlimitedStock = false;
  String _selectedCategory = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFile = await _picker.pickMultiImage();

    if (pickedFile != null) {
      setState(() {
        var y = pickedFile.map((file) => File(file.path));
        for (var im in pickedFile) {
          _images.add(File(im.path));
        }
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  Future<List<String>?> _uploadMedia() async {
    setState(() {
      _isLoading = true;
    });

    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? accessToken = await _prefsService.getToken();
    final String apiUrl =
        'https://sellsajilo-backend.onrender.com/v1/media/upload';
    final request =
        http.MultipartRequest('POST', Uri.parse(apiUrl))
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..fields['name'] = 'product';
    for (var img in _images) {
      request.files.add(await http.MultipartFile.fromPath('files', img.path));
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        final responseData = jsonDecode(responseBody);
        print(responseData);
        return (responseData['medias'] as List)
            .map((m) => m['_id'] as String)
            .toList();
      } else {
        print('Failed to upload media: ${responseBody}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload media: ${responseBody}')),
        );
        return null;
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final SharedPreferences sf = await SharedPreferences.getInstance();
      final String apiUrl =
          'https://sellsajilo-backend.onrender.com/v1/product/create';

      String? accessToken = await _prefsService.getToken();

      final List<String>? mediaIds = await _uploadMedia();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _productNameController.text,
          'desc': _productDescriptionController.text,
          'price': int.parse(_productPriceController.text),
          'discount': int.parse(_discountController.text),
          'profit': int.parse(_profitController.text),
          'stocks': int.parse(_stocksController.text),
          'unlimitedStocks': _unlimitedStock,
          'vendor': sf.getString('vendorId'),
          'category': _selectedCategory,
          'images': [...mediaIds!],
        }),
      );
      print(response.body.toString());
      if (response.statusCode == 201) {
        var body = await jsonDecode(response.body);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details updated successfully')),
        );
      } else {
        print(response.body.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update details: ${response.body}')),
        );
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleCategoryChange(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    // You can now use the selectedCategoryId as needed
    print('Selected Category ID: $categoryId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Details'),
            Text(
              'Add and manage your products.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 200,
            child: PageView(
              children: [
                ..._images.map(
                  (img) => Image.file(
                    img,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Image.asset('assets/images/upload.png', height: 100),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Text(
            "Please fill these details to add a Product",
            style: TextStyle(
              color: Color(0xFF7C7A7A),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.23,
            ),
          ),
          SizedBox(height: 14),
          Text('Product Name', style: Theme.of(context).textTheme.displaySmall),
          Text(
            'This product name will display to buyers',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _productNameController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Air Force 1 Jester XX Black Sonic Yellow',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Product Description',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'This product description will display to buyers',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _productDescriptionController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Air Force 1 Jester XX Black Sonic Yellow',
            ),
            maxLines: 15,
            minLines: 10,
          ),
          SizedBox(height: 20),
          Text(
            'Product Price (Rs)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'This is the price for calculating your profit stats.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _productPriceController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '4999'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Text(
            'Discount Price (Rs)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'It is the price to show user as discount',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _discountController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: '400',
              hintStyle: TextStyle(color: Color(0xFF7C7A7A)),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Text(
            'Profit Price (Rs)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'This is the actual price client will buy the product at.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _profitController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '4999'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Text('Categories', style: Theme.of(context).textTheme.displaySmall),
          Text(
            'Select all the categories this product belongs to.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          CategoriesDropdown(onChanged: handleCategoryChange),
          SizedBox(height: 20),
          Text('Stocks', style: Theme.of(context).textTheme.displaySmall),
          Text(
            'No of stocks(items) of this product available in your inventory.',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _stocksController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(hintText: '99'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              title: Text(
                "Unlimited Stock",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              value: _unlimitedStock,
              onChanged: (newValue) {
                setState(() {
                  _unlimitedStock = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _addProducts,
            child:
                _isLoading
                    ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                    : const Text(
                      'Add products',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
