import 'package:flutter/material.dart';
import 'package:how_old/models/how_old_model.dart';
import 'package:how_old/resources/color_resources.dart';
import 'package:how_old/resources/style_resources.dart';
import 'package:how_old/screens/search_result_screen.dart';
import 'package:lottie/lottie.dart';

//region AppBar widget
Widget topBar(String title){
  return AppBar(
    title: textWidget(title, StyleResources.appBarStyle),
    iconTheme: IconThemeData(color: ColorResources.colorOrange),
    elevation: 0.0,
    backgroundColor: ColorResources.colorBlack,
    brightness: Brightness.dark,
  );
}
//endregion

Widget lottieWidget(String lottieImage, double _height, double _width) {
  return Center(
      child: Lottie.asset(
        lottieImage,
        width: _width,
        height: _height,
      ));
}

Widget textAlignWidget(String text, TextStyle textStyle, TextAlign _textAlign) {
  return Text(
      text,
      textAlign: _textAlign,
      style: textStyle);
}

Widget textWidget(String text, TextStyle textStyle) {
  return Text(
      text,
      style: textStyle);
}

Widget hwAssetImageWidget(String imageUrl, double _height, double _width, bool isBoxFit) {
  return isBoxFit
      ? Image.asset(
      imageUrl,
      width: _width,
      height: _height,
      fit: BoxFit.contain)
      : Image.asset(
    imageUrl,
    width: _height,
    height: _width,
  );
}

//region delegate class for search functionality
class MySearchModel extends SearchDelegate<HowOldModel> {
  List<HowOldModel> hoModel;
  MySearchModel({this.hoModel});

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear, color: ColorResources.colorBlack, size: 24.0),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back, color: ColorResources.colorBlack, size: 24.0,),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return ListTile(
      title: textWidget(query, StyleResources.defaultTextStyle)
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final myList = query.isEmpty
        ? hoModel
        : hoModel.where((element) => element.technology.toLowerCase()
        .contains(query.toLowerCase())).toList();
    return myList.isEmpty
        ? ListTile(title: textWidget("No results found.", StyleResources.defaultTextStyle))
        : ListView.builder(
      itemCount: myList.length,
      itemBuilder: (context, index) {
        final HowOldModel howOldModel = myList[index];
        return ListTile(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SearchResultScreen(myModel: howOldModel)));
            showResults(context);
          },
          title: textWidget(howOldModel.technology, StyleResources.defaultTextStyle)
        );
      },
    );
  }
}
//endregion

//region wave like container
class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 20;
    final highPoint = size.height - 40;

    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
//endregion