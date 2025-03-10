import 'image_modal.dart';

class VendorData {
  String id;
  String shopName;
  List<String> domains;
  String fullAddress;
  String phone;
  String location;
  List<String> owners;
  ImageData logo;
  String brandColor;
  String facebook;
  String instagram;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String khaltiKey;

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
