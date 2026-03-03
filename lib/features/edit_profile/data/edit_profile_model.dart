class EditProfileGet {
  bool? success;
  Data? data;

  EditProfileGet({this.success, this.data});

  factory EditProfileGet.fromJson(Map<String, dynamic> json) => EditProfileGet(
    success: json['success'] as bool?,
    data: json['data'] == null
        ? null
        : Data.fromJson(Map<String, dynamic>.from(json['data'])),
  );

  Map<String, dynamic> toJson() => {'success': success, 'data': data?.toJson()};
}

class Data {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;

  Data({this.id, this.name, this.email, this.phone, this.address, this.image});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'] as int?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'image': image,
  };
}
