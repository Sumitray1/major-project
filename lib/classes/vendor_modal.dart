import 'image_modal.dart';

class VendorData {
  final String id;
  final String shopName;
  final List<String> domains;
  final String fullAddress;
  final String phone;
  final String location;
  final List<String> owners;
  final ImageData logo;
  final String brandColor;
  final String facebook;
  final String instagram;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String khaltiKey;

  VendorData({
    required this.id,
    required this.shopName,
    required this.domains,
    required this.fullAddress,
    required this.phone,
    required this.location,
    required this.owners,
    required this.logo,
    required this.brandColor,
    required this.facebook,
    required this.instagram,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.khaltiKey,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      id: json['_id'],
      shopName: json['shopName'],
      domains: List<String>.from(json['domains']),
      fullAddress: json['fullAddress'],
      phone: json['phone'],
      location: json['location'],
      owners: List<String>.from(json['owners']),
      logo: ImageData.fromJson(json['logo']),
      brandColor: json['brandColor'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      khaltiKey: json['khaltikey'],
    );
  }
}
