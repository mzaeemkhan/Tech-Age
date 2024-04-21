import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:how_old/models/how_old_model.dart';
import 'package:how_old/resources/string_resources.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//region show and hide functions for progress dialog
Future showLoading() async {
  await EasyLoading.show(status: "Please wait...");
}

Future hideLoading() async {
  await EasyLoading.dismiss();
}
//endregion

//region api call function to fetch json data
Future<List<HowOldModel>> readJsonFromAPI(String url) async {
  List<HowOldModel> result = new List.empty(growable: true);
  try {
    var getResult = await http.get(Uri.parse(url)
        , headers: {
          StringResources.apiKeyHeader: StringResources.apiKey
        }
    ).timeout(Duration(seconds: 30),
        onTimeout: () {
          return http.Response("Error", StringResources.timeoutCode);
        });
    if(getResult.statusCode == 200){
      var responseJson = json.decode(getResult.body);
      if(responseJson != null){
        List<HowOldModel> dataList = responseJson.map<HowOldModel>((json) => HowOldModel.fromJson(json)).toList();
        result.addAll(dataList);
        return result;
      }
      else{
        return result;
      }
    }
    else{
      return result;
    }
  } on TimeoutException catch (e) {
    print("Time Out: $e");
    return result;
  } on SocketException catch (e) {
    print("Socket: $e");
    return result;
  } on Error catch (e) {
    print("Error: $e");
    return result;
  }

  // var dataList;
  //
  // return https.get(Uri.parse(url)).then((https.Response response) {
  //   final int statusCode = response.statusCode;
  //
  //   if (statusCode < 200 || statusCode > 400 || json == null) {
  //     throw new Exception("Error while fetching data");
  //   }
  //
  //   var responseJson = json.decode(response.body);
  //
  //   dataList = responseJson.map<HowOldModel>((json) =>
  //       HowOldModel.fromJson(json)).toList();
  //
  //   return dataList;
  // });
}
//endregion

//region URL Launcher
Future<void> launchURL(String url) async {
  await showLoading();

  if (!url.contains('http')) url = 'https://$url';

  try{
    await launchUrl(Uri.parse(url));
    await hideLoading();
  }catch(exception){
    await hideLoading();
  }
}
//endregion

//region Check If We Are Connected To The Internet
Future<bool> internetConnected() async {
  bool isConnected;
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
    }
  } on SocketException catch (_) {
    isConnected = false;
  }

  return isConnected;
}
//endregion