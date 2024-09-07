class UserDetailsModel {
  String firstName;
  String lastName;
  String email;
  String phone;

  UserDetailsModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic>? json) {
    return UserDetailsModel(
      firstName: json?['firstName'],
      lastName: json?['lastName'],
      email: json?['email'],
      phone: json?['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }
}
