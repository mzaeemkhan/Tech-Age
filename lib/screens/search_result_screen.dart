import 'package:flutter/material.dart';
import 'package:how_old/models/how_old_model.dart';
import 'package:how_old/resources/color_resources.dart';
import 'package:how_old/resources/style_resources.dart';
import 'package:how_old/util/util.dart';
import 'package:how_old/widgets/custom_widgets.dart';

// ignore: must_be_immutable
class SearchResultScreen extends StatefulWidget {
  HowOldModel myModel = new HowOldModel();
  SearchResultScreen({Key key, this.myModel}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      appBar: topBar(""),
      body: SafeArea(
        child: InkWell(
          onTap: () {
            launchURL(widget.myModel.technologyLink);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: ColorResources.colorBlack,
            ),
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: textAlignWidget(widget.myModel.technology, StyleResources.orangeTextStyle, TextAlign.left)
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: textAlignWidget("has been out for", StyleResources.whiteTextStyle, TextAlign.center)
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: textAlignWidget(((widget.myModel.ageDifference ~/ 365).toInt()).toString() + " Years", StyleResources.orangeLightTextStyle, TextAlign.right)
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}