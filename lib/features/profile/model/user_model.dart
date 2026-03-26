
class UserModel {
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    this.avatarUrl,
  });

  final String  firstName;
  final String  lastName;
  final String  userName;
  final String  email;
  final String? avatarUrl;


  String get fullName => '$firstName $lastName';


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['first_name'] as String,
        lastName:  json['last_name']  as String,
        userName:  json['username']   as String,
        email:     json['email']      as String,
        avatarUrl: json['avatar_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name':  lastName,
        'username':   userName,
        'email':      email,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? userName,
    String? email,
    String? avatarUrl,
  }) =>
      UserModel(
        firstName: firstName ?? this.firstName,
        lastName:  lastName  ?? this.lastName,
        userName:  userName  ?? this.userName,
        email:     email     ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}