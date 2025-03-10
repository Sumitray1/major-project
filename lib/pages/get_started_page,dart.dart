import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  _GetSartedpageState createState() => _GetSartedpageState();
}

class _GetSartedpageState extends State<GetStartedPage> {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _subDomainController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fbLinkController = TextEditingController();
  final TextEditingController _instaLinkController = TextEditingController();
  File? _image;
  Color _selectedColor = Colors.blue;
  String? imageId;
  String? imageUrl;
  bool _isLoading = false;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload media
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
          ..fields['name'] = 'logo'
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

  // Function to open the color picker dialog
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick a Brand Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true, // Show color code label
              pickerAreaHeightPercent:
                  0.8, // Adjust the height of the color picker area
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print(_phoneNumberController.text);
      print('Updating Details...');
      final String apiUrl =
          'https://sellsajilo-backend.onrender.com/v1/vendors/create';

      String? accessToken = await _prefsService.getToken();
      print(accessToken);

      final String? mediaId = await _uploadMedia();
      if (mediaId == null || mediaId.isEmpty || mediaId.length > 255) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid media ID')));
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // JSON Header
        },
        body: jsonEncode({
          'logo': mediaId,
          'shopName': _storeNameController.text,
          'location': _locationController.text,
          'fullAddress': _fullAddressController.text,
          'domains': [_subDomainController.text], // List
          'phone': _phoneNumberController.text,
          'facebook': _fbLinkController.text,
          'instagram': _instaLinkController.text,
          'brandColor':
              "#${_selectedColor.value.toRadixString(16)}", // Convert Color to Hex String
        }),
      );

      if (response.statusCode == 201) {
        var body = await jsonDecode(response.body);
        final SharedPreferences sf = await SharedPreferences.getInstance();
        sf.setString('vendorId', body['_id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details updated successfully')),
        );
        Navigator.pushNamed(context, '/product-page');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Image.asset(
          "assets/images/back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        ListView(
          children: [
            Image.asset("assets/images/company.png", height: 300),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFFF6F6F6)),
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
                          text: 'Start by \nKnowing Your ',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Business',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: Color(0xFF3F6784),
                          ),
                        ),
                        TextSpan(
                          text: ' info ',
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
                    'Provide us Your logo & store name',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  // Image Picker Button
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Center(
                      child:
                          _image == null
                              ? Image.asset('assets/images/logoUpload.png')
                              : Image.file(
                                _image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Store Name',

                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _storeNameController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'eg. Sassy Baneshwor',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Google map address link',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Full Address',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _fullAddressController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(hintText: 'Full Address'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _phoneNumberController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(hintText: '+9779800000000'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Facbook Link',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _fbLinkController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'facebook.com/your-username',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Instagram Link',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _instaLinkController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'instagram.com/your-username',
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'sub Domain',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _subDomainController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(hintText: 'sassybaneshwor'),
                  ),
                  SizedBox(height: 8),

                  Text(
                    'https://sassybaneshwor.nebulasansar.com',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Brand Color',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 20),

                  // Show selected color
                  GestureDetector(
                    onTap: _openColorPicker,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            color: _selectedColor, // Display selected color
                          ),
                          SizedBox(width: 16),
                          Text(
                            '#'
                            '${(_selectedColor.a * 255).toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
                            '${(_selectedColor.r * 255).toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
                            '${(_selectedColor.g * 255).toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
                            '${(_selectedColor.b * 255).toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updateDetails,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : const Text(
                              'Update',
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
          ],
        ),
      ],
    ),
  );
}
