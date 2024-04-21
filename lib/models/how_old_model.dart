import 'dart:convert';
import 'package:intl/intl.dart';

List<HowOldModel> howOldModelFromJson(String str) => List<HowOldModel>.from(json.decode(str).map((x) => HowOldModel.fromJson(x)));

String howOldModelToJson(List<HowOldModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HowOldModel {
  HowOldModel({
    this.howOldId,
    this.technologyLink,
    this.technology,
    this.technologyYears,
    this.insertedTime,
    this.ageDifference
  });

  int howOldId;
  String technologyLink;
  String technology;
  String technologyYears;
  DateTime insertedTime;
  int ageDifference;

  factory HowOldModel.fromJson(Map<String, dynamic> json) => HowOldModel(
    howOldId: json["howOldId"],
    technologyLink: json["technologyLink"],
    technology: json["technology"],
    technologyYears: json["technologyYears"],
    insertedTime: DateTime.parse(json["insertedTime"]),
    ageDifference: DateFormat.yMd().parse(DateFormat.yMd().format(DateTime.now())).difference(DateFormat.yMd().parse(json["technologyYears"])).inDays
  );

  Map<String, dynamic> toJson() => {
    "howOldId": howOldId,
    "technologyLink": technologyLink,
    "technology": technology,
    "technologyYears": technologyYears,
    "insertedTime": insertedTime.toIso8601String(),
    "ageDifference": ageDifference
  };
}
