class DoctorModel {
  String? id;
  String? image;
  String? fullName;
  String? age;
  String? gender;
  String? category;
  String? position;
  String? aboutDoctor;
  String? startTime;
  String? endTime;
  String? patients;
  String? experience;
  int? rating;
  List? wishList;

  DoctorModel({
    this.id,
    this.image,
    this.fullName,
    this.age,
    this.gender,
    this.category,
    this.position,
    this.startTime,
    this.endTime,
    this.aboutDoctor,
    this.patients,
    this.experience,
    this.rating,
    this.wishList,
  });

  factory DoctorModel.fromJson(String id, Map<String, dynamic> json) {
    return DoctorModel(
      id: id,
      image: json['image'],
      fullName: json['fullName'],
      age: json['age'],
      gender: json['gender'],
      category: json['category'],
      position: json['position'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      aboutDoctor: json['aboutDoctor'],
      patients: json['patients'],
      experience: json['experience'],
      rating: json['rating'],
      wishList: List<String>.from(json['wishlist']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'category': category,
      'position': position,
      'startTime': startTime,
      'endTime': endTime,
      'aboutDoctor': aboutDoctor,
      'patients': patients,
      'experience': experience,
      'rating': rating,
      'wishlist': wishList
    };
  }
}
