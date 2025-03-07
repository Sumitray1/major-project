import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:major_project/services/shared_preferences_service.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String apiUrl =
          'https://sellsajilo-backend.onrender.com/v1/user/verify-otp';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Ensures JSON format
        },
        body: jsonEncode({
          'otp': int.parse(_otpController.text), // OTP sent as an integer
          'email': widget.email,
        }),
      );

      if (response.statusCode == 201) {
        var body = jsonDecode(response.body);
        SharedPreferencesService sf = SharedPreferencesService();
        await sf.saveToken(body['token']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verification successful')),
        );

        // Check if the vendor list is empty
        await _checkVendorList();
      } else {
        print(response.body.toString());
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkVendorList() async {
    try {
      final String apiUrl =
          'https://sellsajilo-backend.onrender.com/v1/vendors/get-my-vendors';

      SharedPreferencesService sf = SharedPreferencesService();
      String? accessToken = await sf.getToken();

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body.isNotEmpty) {
          SharedPreferences sf = await SharedPreferences.getInstance();
          sf.setString('vendorId', body[0]['_id']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (_) => false,
          );
        } else {
          Navigator.pushNamed(context, '/Get-started');
        }
      } else {
        print(response.body.toString());
        throw Exception('Failed to fetch vendor list');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/back.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: Image.asset("assets/images/otp.png"),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 393,
                width: 422,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0xFFF6F6F6)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Reach ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Color(0xFF3F6784),
                        ),
                        children: [
                          TextSpan(
                            text: 'millions',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' by',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        text: 'Creating ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'website',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Color(0xFF3F6784),
                            ),
                          ),
                          TextSpan(
                            text: ' instantly',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      "Enter the 6-digit pin sent to your mail ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "Poppins",
                      ),
                    ),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        color: Color(0xFF446785),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.56,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Pinput(
                      controller: _otpController,
                      length: 6,
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 49,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Add OTP resend logic here
                        },
                        child: const Text(
                          "Resend Pin",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF446785),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
