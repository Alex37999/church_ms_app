class Login {
  bool? success;
  String? message;
  String? token;
  Member? member;

  Login({this.success, this.message, this.token, this.member});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      token: json['token'] as String?,
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'token': token,
    'member': member?.toJson(),
  };
}

class Member {
  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic memberNumber;
  String? image;
  bool? isManager;
  int? branchId;

  Member({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.memberNumber,
    this.image,
    this.isManager,
    this.branchId,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json['id'] as int?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    memberNumber: json['member_number'],
    image: json['image'] as String?,
    isManager: json['isManager'] as bool?,
    branchId: json['branch_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'member_number': memberNumber,
    'image': image,
    'isManager': isManager,
    'branch_id': branchId,
  };
}
