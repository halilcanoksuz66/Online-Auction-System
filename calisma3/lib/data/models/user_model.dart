class UserModel {
  String? uid;
  String name;
  String surname;
  String username;
  String email;
  String password;
  String? profilePhoto;

  UserModel(
      {this.uid,
      required this.name,
      required this.surname,
      required this.username,
      required this.email,
      required this.password,
      this.profilePhoto});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
      'password': password,
      'profilePhoto': profilePhoto
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] as String,
      surname: map['surname'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      username: map['username'] as String,
      profilePhoto:
          map['profilePhoto'] != null ? map['profilePhoto'] as String : null,
    );
  }
}
