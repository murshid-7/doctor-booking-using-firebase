import 'package:grocery_online_shop/model/doctor_model.dart';

class AppointmentModel {
  String? id;
  String? uId;
  String? docId;
  String? date;
  String? time;
  String? status;
  DoctorModel? doctor;

  AppointmentModel(
      {this.id,
      this.uId,
      this.docId,
      required this.date,
      required this.time,
      this.status,
      this.doctor});

  factory AppointmentModel.fromJson(String id, Map<String, dynamic> json) {
    return AppointmentModel(
      id: id,
      uId: json['userId'],
      docId: json['docId'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      doctor: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': uId,
      'docId': docId,
      'id': id,
      'date': date,
      'time': time,
      'status': status,
    };
  }

  bool isCanceled() {
    return status == 'canceled';
  }
}
