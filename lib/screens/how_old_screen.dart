import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:how_old/generated/assets.dart';
import 'package:how_old/models/how_old_model.dart';
import 'package:how_old/resources/color_resources.dart';
import 'package:how_old/resources/font_resources.dart';
import 'package:how_old/resources/image_resources.dart';
import 'package:how_old/resources/string_resources.dart';
import 'package:how_old/resources/style_resources.dart';
import 'package:how_old/shared_preference/shared_preference.dart';
import 'package:how_old/util/util.dart';
import 'package:how_old/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class HowOldScreen extends StatefulWidget {
  const HowOldScreen({Key key}) : super(key: key);

  @override
  _HowOldScreenState createState() => _HowOldScreenState();
}

class _HowOldScreenState extends State<HowOldScreen> {
  //region Required Variables
  String containerText = "";
  bool _showBackToTopButton = false;
  bool visible = false;
  ScrollController _scrollController;
  var f = new DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  String date = "select your age...";
  String differenceInYears = "";
  int _currentValue;
  final snackBar = SnackBar(content: Text('No data for sorting.'));
  final snackBarNoInternet = SnackBar(content: Text('Not connected to internet.'));
  // ProgressDialog pr;
  //endregion

  //region Init and Dispose Functions
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //region data collecting call
    readJsonFromAPI(StringResources.myUrl).then((value) {
      setState(() {
        StringResources.howOldData = value;

        StringResources.howOldMinAge = getMinAge(StringResources.howOldData);
        _currentValue = StringResources.howOldMinAge;
        StringResources.howOldMaxAge = getMaxAge(StringResources.howOldData);

        // region Sort Data by Technology
        StringResources.howOldData.sort((howOld1, howOld2)
        {
          return howOld1.technology.compareTo(howOld2.technology);
        });
        // endregion

        StringResources.howOldAgeWise = List.from(StringResources.howOldData);

        StringResources.isTech = true;
        StringResources.isAge = false;
        StringResources.isTechAscending = true;
        StringResources.isAgeAscending = false;

        sortingAccordingToPrevious();
      });
    });
    //endregion

    //region scroll listener setting
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= 300) {
          if(!_showBackToTopButton){
            setState(() {
              _showBackToTopButton = true;
            });
          }
        } else {
          if(_showBackToTopButton){
            setState(() {
              _showBackToTopButton = false;
            });
          }
        }
      });
    //endregion
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: Scaffold(
        backgroundColor: ColorResources.whiteColor,
        body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var result = snapshot.data;
            switch (result) {
              case ConnectivityResult.none:
                // return StringResources.howOldData != null
                //     ? bodyWidget()
                //     : SafeArea(
                //     child: Container(
                //         child: lottieWidget(
                //             Assets.lottie58200NoInternet,
                //             MediaQuery.of(context).size.height,
                //             MediaQuery.of(context).size.width)));
                break;
              case ConnectivityResult.mobile:
              case ConnectivityResult.wifi:
                Timer(Duration(seconds: 5), () {
                  if (StringResources.howOldData == null) {
                    _refreshData(context);
                  }
                  else if(StringResources.howOldData.isEmpty){
                    _refreshData(context);
                  }
                });
                break;
              default:
                break;
                // return StringResources.howOldData != null
                //     ? bodyWidget()
                //     : SafeArea(
                //     child: Container(
                //         child: lottieWidget(
                //             Assets.lottie58200NoInternet,
                //             MediaQuery.of(context).size.height,
                //             MediaQuery.of(context).size.width)));
            }
            return StringResources.howOldData != null ? (StringResources.howOldData.isNotEmpty ? bodyWidget(): SafeArea(
                child: Container(
                    child: lottieWidget(
                        Assets.lottie58200NoInternet,
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width)))) : SafeArea(child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.colorOrange),
              ),
            ));
          },
        ),
        floatingActionButton: _showBackToTopButton == false
            ? null
            : FloatingActionButton(onPressed: _scrollToTop, child: Icon(Icons.arrow_upward, color: ColorResources.colorBlack, size: 24,), backgroundColor: ColorResources.colorOrange,
        )
      ),
    );
  }

  //region Body
  Widget bodyWidget() {
    return StringResources.howOldData != null
        ? SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              //region top view stack code
              Stack(
                children: [
                  //region clip container code
                  ClipPath(
                    clipper: WaveClip(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: ColorResources.colorBlack,
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: textAlignWidget('How old are', StyleResources.topTextStyle, TextAlign.left),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.search, color: ColorResources.colorOrange, size: 24.0,),
                                onPressed: () {
                                  showSearch(context: context, delegate: MySearchModel(hoModel: StringResources.howOldData));
                                },
                              )
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        //region year picker dialog
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return StatefulBuilder(
                                                  builder: (context, setState){
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      elevation: 5.0,
                                                      backgroundColor: ColorResources.whiteColor,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: 20.0),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              NumberPicker(
                                                                value: _currentValue,
                                                                minValue: (StringResources.howOldMinAge != null || StringResources.howOldMinAge !=0) ? StringResources.howOldMinAge : 1,
                                                                maxValue: StringResources.howOldMaxAge,
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    _currentValue = value;
                                                                  });
                                                                },
                                                                textStyle: StyleResources.npTextStyle,
                                                                selectedTextStyle: StyleResources.npSelectedTextStyle,
                                                              ),
                                                              SizedBox(height: 30),
                                                              Container(
                                                                clipBehavior: Clip.antiAlias,
                                                                width: double.infinity,
                                                                height: 56.0,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                  color: ColorResources.colorOrange,
                                                                ),
                                                                margin: EdgeInsets.symmetric(horizontal: 40.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Expanded(
                                                                            child: TextButton(
                                                                              style: ButtonStyle(
                                                                                overlayColor: MaterialStateProperty.all(ColorResources.colorBlack),
                                                                                animationDuration: Duration(milliseconds: 3, microseconds: 0),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                _setValues();
                                                                              },
                                                                              child: textWidget('OK', StyleResources.buttonTextStyle)
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              );
                                            });
                                        //endregion
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: ColorResources.colorOrange,
                                                width: 2.0,
                                              ),
                                            ),
                                            color: ColorResources.colorBlack
                                        ),
                                        child: textAlignWidget(date, StyleResources.dateTextStyle, TextAlign.center)
                                      ),
                                    ),
                                    Visibility(
                                      visible: visible,
                                      child: Container(
                                        child: textAlignWidget(_currentValue != 1 ? "years" : "year", StyleResources.yearsTextStyle, TextAlign.center)
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: visible,
                                  child: SizedBox(
                                    width: 10.0,
                                  ),
                                ),
                                Visibility(
                                  visible: visible,
                                  child: TextButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              // side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        minimumSize: MaterialStateProperty.all(Size.zero),
                                        backgroundColor: MaterialStateProperty.all(ColorResources.colorOrange),
                                        overlayColor: MaterialStateProperty.all(ColorResources.orangeColorLight),
                                        animationDuration: Duration(
                                            milliseconds: 3,
                                            microseconds: 0
                                        ),
                                      ),
                                      onPressed: () async {
                                        await showLoading();
                                        setState((){
                                          StringResources.howOldAgeWise.clear();
                                          StringResources.howOldAgeWise = List.from(StringResources.howOldData);
                                          visible = false;
                                          _currentValue = 1;
                                          date = "select your age...";
                                          selectedDate = DateTime.now();
                                        });
                                        await hideLoading();
                                      },
                                      child: textWidget('CLEAR', TextStyle(
                                        fontSize: ScreenUtil().setSp(12.0),
                                        color: ColorResources.colorBlack,
                                        fontFamily: FontResources.newBold,
                                      ))
                                  ),
                                )
                              ]
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: textAlignWidget('you?', StyleResources.topTextStyle, TextAlign.right)
                          ),
                        ],
                      ),
                    ),
                  ),
                  //endregion

                  //region sorting buttons
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if(StringResources.howOldAgeWise.isNotEmpty){
                                await showLoading();
                                setState(() {
                                  if(StringResources.isTechAscending){
                                    StringResources.howOldAgeWise.sort((howOld1, howOld2) {
                                      return howOld2.technology.compareTo(howOld1.technology);
                                    });
                                    StringResources.isTech = true;
                                    StringResources.isTechAscending = false;

                                    StringResources.isAge = false;
                                  }
                                  else{
                                    StringResources.howOldAgeWise.sort((howOld1, howOld2) {
                                      return howOld1.technology.compareTo(howOld2.technology);
                                    });
                                    StringResources.isTech = true;
                                    StringResources.isTechAscending = true;

                                    StringResources.isAge = false;
                                  }
                                });
                                await hideLoading();
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(
                                  color: ColorResources.darkGreyColor.withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 0),
                                )],
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                color: StringResources.isTech ? ColorResources.colorOrange : ColorResources.orangeColorLight,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: textAlignWidget("Tech", StyleResources.defaultTextStyle, TextAlign.center)
                                  ),
                                  Visibility(
                                    visible: StringResources.isTech,
                                    child: SizedBox(
                                      width: 10.0,
                                    ),
                                  ),
                                  Visibility(
                                    visible: StringResources.isTech,
                                    child: Container(
                                      child: Icon(StringResources.isTechAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 24.0, color: ColorResources.colorBlack,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if(StringResources.howOldAgeWise.isNotEmpty){
                                await showLoading();
                                setState(() {
                                  if(StringResources.isAgeAscending){
                                    StringResources.howOldAgeWise.sort((howOld1, howOld2) {
                                      return (howOld2.ageDifference ~/ 365).toInt()
                                          .compareTo((howOld1.ageDifference ~/ 365).toInt());
                                    });
                                    StringResources.isAge = true;
                                    StringResources.isAgeAscending = false;

                                    StringResources.isTech = false;
                                  }
                                  else{
                                    StringResources.howOldAgeWise.sort((howOld1, howOld2) {
                                      return (howOld1.ageDifference ~/ 365).toInt()
                                          .compareTo((howOld2.ageDifference ~/ 365).toInt());
                                    });
                                    StringResources.isAge = true;
                                    StringResources.isAgeAscending = true;

                                    StringResources.isTech = false;
                                  }
                                });
                                await hideLoading();
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(
                                  color: ColorResources.darkGreyColor.withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 0),
                                )],
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                color: StringResources.isAge ? ColorResources.colorOrange : ColorResources.orangeColorLight,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: textAlignWidget("Age", StyleResources.defaultTextStyle, TextAlign.center)
                                  ),
                                  Visibility(
                                    visible: StringResources.isAge,
                                    child: SizedBox(
                                      width: 10.0,
                                    ),
                                  ),
                                  Visibility(
                                    visible: StringResources.isAge,
                                    child: Container(
                                      child: Icon(StringResources.isAgeAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 24.0, color: ColorResources.colorBlack,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  //endregion
                ],
              ),
              //endregion

              //region bottom list related code
              StringResources.howOldAgeWise.isNotEmpty
                  ? Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  scrollDirection: Axis.vertical,
                  itemCount: StringResources.howOldAgeWise.length,
                  itemBuilder: (BuildContext context, int index) {
                    HowOldModel myModel = StringResources.howOldAgeWise[index];
                    return InkWell(
                      onTap: () {
                        launchURL(myModel.technologyLink);
                      } ,
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
                                  child: textAlignWidget(myModel.technology, TextStyle(
                                    fontSize: ScreenUtil().setSp(16.0),
                                    color: StringResources.isTech ? ColorResources.colorOrange : ColorResources.orangeColorLight,
                                    fontFamily: FontResources.newBold,
                                  ), TextAlign.left)
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
                                  child: textAlignWidget(((myModel.ageDifference ~/ 365).toInt()).toString() + " Years", TextStyle(
                                    fontSize: ScreenUtil().setSp(16.0),
                                    color: StringResources.isAge ? ColorResources.colorOrange : ColorResources.orangeColorLight,
                                    fontFamily: FontResources.newBold,
                                  ), TextAlign.right)
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
                  : Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
                child: hwAssetImageWidget(ImageResources.emptyList, MediaQuery.of(context).size.height * 0.5, MediaQuery.of(context).size.width, true)
              ),
              //endregion

              SizedBox(
                height: 50.0,
              )
            ],
          ),
        ))
        : SafeArea(child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.colorOrange),
          ),
        ));
  }
  //endregion

  //region Get Min Age For Age Picker Dialog
  int getMinAge(List<HowOldModel> howOldData) {
    int minValue = 0;
    if(howOldData.isNotEmpty){
      minValue = (howOldData[0].ageDifference ~/ 365).toInt();

      for(int i=0; i<howOldData.length; i++)
      {
        if(((howOldData[i].ageDifference ~/ 365).toInt()) < minValue) {
          minValue = ((howOldData[i].ageDifference ~/ 365).toInt());
        }
      }
    }

    SharedPreference().setMainAge(minValue);
    return minValue;
  }
  //endregion

  //region Get Max Age For Age Picker Dialog
  int getMaxAge(List<HowOldModel> howOldData) {
    int maxValue = 0;
    if(howOldData.isNotEmpty){
      maxValue = (howOldData[0].ageDifference ~/ 365).toInt();

      for(int i=0; i<howOldData.length; i++)
      {
        if(((howOldData[i].ageDifference ~/ 365).toInt()) > maxValue) {
          maxValue = ((howOldData[i].ageDifference ~/ 365).toInt());
        }
      }
    }

    SharedPreference().setMaxAge(maxValue);
    return maxValue;
  }
  //endregion

  //region Pull Down To Refresh Call
  Future<void> _refreshData(BuildContext context) async {
    if (await internetConnected())
    {
      return readJsonFromAPI(StringResources.myUrl).then((value) {
        setState(() {
          StringResources.howOldData = value;

          StringResources.howOldMinAge = getMinAge(StringResources.howOldData);
          _currentValue = StringResources.howOldMinAge;
          StringResources.howOldMaxAge = getMaxAge(StringResources.howOldData);

          // region Sort Data by Technology
          StringResources.howOldData.sort((howOld1, howOld2)
          {
            return howOld1.technology.compareTo(howOld2.technology);
          });
          // endregion

          StringResources.howOldAgeWise = List.from(StringResources.howOldData);

          sortingAccordingToPrevious();
          // StringResources.isTech = true;
          // StringResources.isAge = false;
          // StringResources.isTechAscending = true;
          // StringResources.isAgeAscending = false;
        });
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoInternet);
    }
  }
  //endregion

  //region Scroll Back To Top
  void _scrollToTop() {
    _scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  //endregion

  //region Setting Values After Selecting Age
  void _setValues() {
    setState(() {
      List<HowOldModel> dataAgeWiseNew = new List.empty(growable: true);
      for(int i = 0; i < StringResources.howOldData.length; i++)
      {
        if((StringResources.howOldData[i].ageDifference ~/ 365).toInt() == _currentValue)
        {
          dataAgeWiseNew.add(StringResources.howOldData[i]);
        }
      }

      StringResources.howOldAgeWise.clear();
      StringResources.howOldAgeWise = dataAgeWiseNew;

      date = _currentValue.toString();
      visible = true;
    });
  }
  //endregion

  //region Sorting According To Previous State
  void sortingAccordingToPrevious() {
    if(StringResources.isTech){
      if(StringResources.isTechAscending){
        StringResources.howOldAgeWise.sort((howOld1, howOld2) {
          return howOld1.technology.compareTo(howOld2.technology);
        });
      }
      else{
        StringResources.howOldAgeWise.sort((howOld1, howOld2) {
          return howOld2.technology.compareTo(howOld1.technology);
        });
      }
    }
    else if(StringResources.isAge){
      if(StringResources.isAgeAscending){
        StringResources.howOldAgeWise.sort((howOld1, howOld2) {
          return (howOld1.ageDifference ~/ 365).toInt()
              .compareTo((howOld2.ageDifference ~/ 365).toInt());
        });
      }
      else{
        StringResources.howOldAgeWise.sort((howOld1, howOld2) {
          return (howOld2.ageDifference ~/ 365).toInt()
              .compareTo((howOld1.ageDifference ~/ 365).toInt());
        });
      }
    }
  }
  //endregion
}