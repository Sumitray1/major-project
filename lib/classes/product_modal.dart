import 'image_modal.dart';

class ProductData {
  final String id;
  final String name;
  final String desc;
  final List<ImageData> images;
  final String price;
  final String discount;
  final String profit;
  final String stocks;
  final String vendor;
  final bool unlimitedStocks;
  final DateTime createdAt;
  final DateTime updatedAt;
  ProductData({
    required this.id,
    required this.name,
    required this.desc,
    required this.images,
    required this.price,
    required this.discount,
    required this.profit,
    required this.stocks,
    required this.vendor,
    required this.unlimitedStocks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List;
    List<ImageData> imagesData =
        imagesList.map((i) => ImageData.fromJson(i)).toList();

    return ProductData(
      id: json['_id'],
      name: json['name'],
      desc: json['desc'],
      images: imagesData,
      price: json['price'],
      discount: json['discount'],
      profit: json['profit'],
      stocks: json['stocks'],
      vendor: json['vendor'],
      unlimitedStocks: json['unlimitedStocks'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
