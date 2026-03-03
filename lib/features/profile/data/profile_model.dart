class ProfileGet {
  bool? success;
  Data? data;

  ProfileGet({this.success, this.data});

  factory ProfileGet.fromJson(Map<String, dynamic> json) => ProfileGet(
    success: json['success'] as bool?,
    data: json['data'] == null
        ? null
        : Data.fromJson(Map<String, dynamic>.from(json['data'])),
  );

  Map<String, dynamic> toJson() => {'success': success, 'data': data?.toJson()};
}

class Data {
  int? id;
  dynamic memberNumber;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;
  bool? isManager;
  bool? status;
  Branch? branch;
  Branch? manager;
  DateTime? joinDate;

  Data({
    this.id,
    this.memberNumber,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
    this.isManager,
    this.status,
    this.branch,
    this.manager,
    this.joinDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'] as int?,
    memberNumber: json['member_number'],
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    image: json['image'] as String?,
    isManager: json['isManager'] as bool?,
    status: json['status'] as bool?,
    branch: json['branch'] == null
        ? null
        : Branch.fromJson(Map<String, dynamic>.from(json['branch'])),
    manager: json['manager'] == null
        ? null
        : Branch.fromJson(Map<String, dynamic>.from(json['manager'])),
    joinDate: json['join_date'] == null
        ? null
        : DateTime.tryParse(json['join_date'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'member_number': memberNumber,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'image': image,
    'isManager': isManager,
    'status': status,
    'branch': branch?.toJson(),
    'manager': manager?.toJson(),
    'join_date': joinDate?.toIso8601String(),
  };
}

class Branch {
  int? id;
  String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) =>
      Branch(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
