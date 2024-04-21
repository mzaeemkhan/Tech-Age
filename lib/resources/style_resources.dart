import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_resources.dart';
import 'font_resources.dart';

class StyleResources{

  static TextStyle appBarStyle = TextStyle(
    fontSize: ScreenUtil().setSp(16.0),
    color: ColorResources.colorOrange,
    fontFamily: FontResources.newBold,
  );

  static TextStyle defaultTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(16.0),
    color: ColorResources.colorBlack,
    fontFamily: FontResources.newBold,
  );

  static TextStyle logoTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(16.0),
    color: ColorResources.atruleGreenColor,
  );

  static TextStyle orangeTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(16.0),
    color: ColorResources.colorOrange,
    fontFamily: FontResources.newBold,
  );

  static TextStyle whiteTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(16.0),
    color: ColorResources.whiteColor,
    fontFamily: FontResources.newRegular,
  );

  static TextStyle orangeLightTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(16.0),
    color: ColorResources.orangeColorLight,
    fontFamily: FontResources.newBold,
  );

  static TextStyle dateTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(18.0),
    color: ColorResources.orangeColorLight,
    fontFamily: FontResources.newRegular,
  );

  static TextStyle yearsTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(14.0),
    color: ColorResources.colorOrange,
    fontFamily: FontResources.newRegular,
  );

  static TextStyle topTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(28.0),
    color: ColorResources.colorOrange,
    fontFamily: FontResources.top,
  );

  static TextStyle npTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(18.0),
    color: ColorResources.colorBlack,
    fontFamily: FontResources.newRegular,
  );

  static TextStyle npSelectedTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(28.0),
    color: ColorResources.colorBlack,
    fontFamily: FontResources.newBold,
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(18.0),
    color: ColorResources.whiteColor,
    fontFamily: FontResources.newBold,
  );
}