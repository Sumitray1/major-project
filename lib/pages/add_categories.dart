import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:major_project/Widgets/categories_card.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  File? _image;
  bool _isLoading = false;
  final TextEditingController _categoryNameController = TextEditingController();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    final String apiUrl =
        'https://sellsajilo-backend.onrender.com/v1/category/all/$vendorId';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      List<Category> categories =
          (responseData['categories'] as List)
              .map((data) => Category.fromJson(data))
              .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _refreshCategories() async {
    setState(() {
      _categoriesFuture = _fetchCategories();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  Future<String?> _uploadMedia() async {
    if (_image == null) return null;

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
          ..fields['name'] = 'product'
          ..files.add(await http.MultipartFile.fromPath('files', _image!.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        final responseData = jsonDecode(responseBody);
        return responseData['medias'][0]['_id'];
      } else {
        print('Failed to upload media: ${responseBody}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload media: ${responseBody}'),
            backgroundColor: Colors.red, // Change this to your desired color
          ),
        );
        return null;
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red, // Change this to your desired color
        ),
      );
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addCategory() async {
    if (_categoryNameController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide a category name and image'),
          backgroundColor: Colors.red, // Change this to your desired color
        ),
      );
      return;
    }

    final String? mediaId = await _uploadMedia();
    if (mediaId == null || mediaId.isEmpty || mediaId.length > 255) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid media ID'),
          backgroundColor: Colors.red, // Change this to your desired color
        ),
      );
      return;
    }

    SharedPreferencesService sf = SharedPreferencesService();
    String? accessToken = await sf.getToken();
    final SharedPreferences sfg = await SharedPreferences.getInstance();
    String? vendorId = sfg.getString('vendorId');

    if (vendorId == null || vendorId.isEmpty || vendorId.length > 255) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid vendor ID'),
          backgroundColor: Colors.red, // Change this to your desired color
        ),
      );
      return;
    }

    final String apiUrl =
        'https://sellsajilo-backend.onrender.com/v1/category/create';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _categoryNameController.text,
        'image': mediaId,
        'vendorId': vendorId,
      }),
    );
    print('mediaaaa id');
    print(mediaId);
    print('vendor');
    print(vendorId);
    print(_categoryNameController.text);
    try {
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category added successfully'),
            backgroundColor: Colors.green, // Change this to your desired color
          ),
        );
        Navigator.of(context).pop();
        _refreshCategories();
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add category: ${response.body}'),
            backgroundColor: Colors.red, // Change this to your desired color
          ),
        );
      }
    } catch (e) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red, // Change this to your desired color
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories'),
            Text(
              'View and manage your categories.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCategories,
        child: FutureBuilder<List<Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories found'));
            } else {
              final categories = snapshot.data!;
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Expanded(
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search for categories',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    '${categories.length} categories Found',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 14),
                  GridView.count(
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 1.04,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        categories.map((category) {
                          return SizedBox(
                            child: CategoriesCard(
                              id: category.id,
                              imageUrl: category.image.path,
                              name: category.name,
                              key: Key(category.id),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Color(0xFFF6F6F6),
              title: Text(
                'Add Category',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              content: SizedBox(
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        await _pickImage();
                        setState(() {}); // Update the state within the dialog
                      },
                      child: Center(
                        child:
                            _image == null
                                ? Image.asset(
                                  'assets/images/upload.png',
                                  width:
                                      MediaQuery.of(context).size.width *
                                      0.3, // 30% of screen width
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.2, // 20% of screen height
                                  fit: BoxFit.contain,
                                )
                                : Image.file(
                                  _image!,
                                  width:
                                      MediaQuery.of(context).size.width *
                                      0.3, // Responsive width
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.2, // Responsive height
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Category name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _categoryNameController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(hintText: 'Shoes'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await _addCategory();
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : const Text(
                                'Add category',
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
              ),
            );
          },
        );
      },
    );
  }
}

class Category {
  final String id;
  final String name;
  final String vendor;
  final ImageData image;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.vendor,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      vendor: json['vendor'],
      image: ImageData.fromJson(json['image']),
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ImageData {
  final String id;
  final String name;
  final String type;
  final String path;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ImageData({
    required this.id,
    required this.name,
    required this.type,
    required this.path,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      path: json['path'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
