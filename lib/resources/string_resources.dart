import 'package:how_old/models/how_old_model.dart';

class StringResources {
  static const bool isOnline = true;
  static const String companyName = "ATRULE Technologies";

  static List<HowOldModel> howOldData;
  static List<HowOldModel> howOldAgeWise;
  static int howOldMinAge;
  static int howOldMaxAge;

  static bool isTech = true;
  static bool isAge = false;

  static bool isTechAscending = true;
  static bool isAgeAscending = false;

  static int timeoutCode = 10000;

  //region Api Url List
  static const String apiKeyHeader = "ApiKey";
  static const String apiKey = "jWxwuc7GPUX8Neq4NhDJpqGJgbpdnd9AwWjNdpAf53VSz4WPzVVtS2L2hsfv7s9eExe5MecAcEK7kkQ3bxfvPvap3a65eJdhATCEBGXegxQRWakGQJF5KbHNe7ubhpZ7";

  static String apiUrl = "http://api.atrule.com";
  static String myUrl = apiUrl + "/api/HowOldAreYou";
//endregion
}