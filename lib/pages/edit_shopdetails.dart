import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:major_project/classes/vendor_modal.dart';

class EditShopPage extends StatefulWidget {
  const EditShopPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditShopPage> {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _subDomainController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fbLinkController = TextEditingController();
  final TextEditingController _instaLinkController = TextEditingController();
  final TextEditingController _kahltikeyController = TextEditingController();
  File? _image;
  Color _selectedColor = const Color.fromARGB(255, 0, 0, 0);
  bool _isLoading = false;
  String imgurl = '';
  String imgid = '';

  @override
  void initState() {
    super.initState();
    _fetchVendorData();
  }

  Future<void> _fetchVendorData() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://sellsajilo-backend.onrender.com/v1/vendors/get-vendor/id/$vendorId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final vendorData = VendorData.fromJson(data);

        setState(() {
          _storeNameController.text = vendorData.shopName;
          _locationController.text = vendorData.location;
          _fullAddressController.text = vendorData.fullAddress;
          _subDomainController.text =
              vendorData.domains.isNotEmpty ? vendorData.domains[0] : '';
          _phoneNumberController.text = vendorData.phone;
          _fbLinkController.text = vendorData.facebook;
          _instaLinkController.text = vendorData.instagram;
          _kahltikeyController.text = vendorData.khaltiKey!;
          imgurl = vendorData.logo.path;
          imgid = vendorData.logo.id;
          _selectedColor = Color(
            int.parse(vendorData.brandColor.replaceFirst('#', '0xff')),
          );
        });
      } else {
        print(response.body);
        throw Exception('Failed to load vendor data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? vendorId = sf.getString('vendorId');
    setState(() {
      _isLoading = true;
    });

    try {
      print(_phoneNumberController.text);

      final String apiUrl =
          'https://sellsajilo-backend.onrender.com/v1/vendors/update-my-vendor/$vendorId';

      String? accessToken = await _prefsService.getToken();
      print(accessToken);

      final String? mediaId = imgurl.isEmpty ? await _uploadMedia() : imgid;

      if (mediaId == null || mediaId.isEmpty || mediaId.length > 255) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid media ID'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final response = await http.put(
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
          'khaltikey': _kahltikeyController.text,
          'brandColor':
              "#${_selectedColor.value.toRadixString(16)}", // Convert Color to Hex String
        }),
      );

      if (response.statusCode == 200) {
        var body = await jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Details updated successfully'),
            backgroundColor: Colors.green, // ✅ Success color
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/mystore',
          (route) => false,
        );
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update details: ${response.body}'),
            backgroundColor: Colors.orange, // ⚠️ Warning color
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red, // ❌ Error color
        ),
      );
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
                      text: 'Edits  ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Color(0xFF3F6784),
                      ),
                      children: [
                        TextSpan(
                          text: 'You Shop Informations',
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
                  Text(
                    'Edit Image',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Optional: For rounded corners
                          child:
                              _image == null
                                  ? (imgurl.isNotEmpty
                                      ? Image.network(
                                        imgurl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        'assets/images/logoUpload.png',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ))
                                  : Image.file(
                                    _image!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                Colors.black54, // Background color for contrast
                            child: IconButton(
                              onPressed: () {
                                _pickImage();
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero, // Removes extra padding
                              constraints:
                                  BoxConstraints(), // Removes extra constraints
                            ),
                          ),
                        ),
                      ],
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
                    'Khalti Key',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: _kahltikeyController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '0b1804d0997a4905a6852ab62b5',
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
                    'https://${_subDomainController.text}',
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
                              'Update Info',
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
