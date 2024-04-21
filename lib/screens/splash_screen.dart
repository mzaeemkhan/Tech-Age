import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:how_old/generated/assets.dart';
import 'package:how_old/resources/color_resources.dart';
import 'package:how_old/resources/image_resources.dart';
import 'package:how_old/resources/string_resources.dart';
import 'package:how_old/resources/style_resources.dart';
import 'package:how_old/screens/how_old_screen.dart';
import 'package:how_old/widgets/custom_widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Column(
        children: [
          //region middle area of splash
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
              child: hwAssetImageWidget(
                  Assets.imagesSplashImage, double.infinity, double.infinity, false),
            ),
          ),
          //endregion

          //region bottom area where have company information
          Expanded(
            flex: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  hwAssetImageWidget(ImageResources.atruleIcon, 50.0, 50.0, false),
                  textWidget(StringResources.companyName, StyleResources.logoTextStyle)
                ],
              ),
            ),
          ),
          //endregion
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //region hide status bar and set timer
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => HowOldScreen()));
    });
    //endregion
  }

  @override
  void dispose() {
    super.dispose();

    //region show status bar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    //endregion
  }
}
