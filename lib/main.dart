import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:how_old/resources/color_resources.dart';
import 'package:how_old/screens/splash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: ColorResources.colorBlack,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
