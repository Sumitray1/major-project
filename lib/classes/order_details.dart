class OrderDetailsData {
  final String id;
  final String fname;
  final String lname;
  final String address;
  final String phone;
  final String email;
  final String product;
  final String vendor;
  final String price;
  final String discount;
  final String priceAfterDiscount;
  final String profit;
  final String qty;
  final String domain;
  final int otp;
  final String bookingStatus;
  final String paymentStatus;
  final String paymentMethod;
  final bool isDeleted;
  final DateTime updatedAt;
  final DateTime createdAt;

  OrderDetailsData({
    required this.id,
    required this.fname,
    required this.lname,
    required this.address,
    required this.phone,
    required this.email,
    required this.product,
    required this.vendor,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.profit,
    required this.qty,
    required this.domain,
    required this.otp,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.isDeleted,
    required this.updatedAt,
    required this.createdAt,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    return OrderDetailsData(
      id: json['_id'],
      fname: json['fname'],
      lname: json['lname'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      product: json['product'],
      vendor: json['vendor'],
      price: json['price'],
      discount: json['discount'],
      priceAfterDiscount: json['priceAfterDiscount'],
      profit: json['profit'],
      qty: json['qty'],
      domain: json['domain'],
      otp: json['otp'],
      bookingStatus: json['bookingStatus'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      isDeleted: json['isDeleted'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
