class UserModel {
  String? uId;
  String? userName;
  String? email;
  String? age;
  String? image;
  String? gender;
  String? phoneNumber;

  UserModel(
      {this.uId,
      this.userName,
      this.email,
      this.phoneNumber,
      this.image,
      this.age,
      this.gender});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uId: json['userId'],
        userName: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        image: json['image'],
        age: json['age'],
        gender: json['gender']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': uId,
      'name': userName,
      'email': email,
      'image': image,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender
    };
  }
}
