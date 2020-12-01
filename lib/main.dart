import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'model/car.dart';

void main() {
  runApp(MyApp());
}

var currentCar = carList.cars[0];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.only(left: 25),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 25),
            child: Icon(Icons.favorite_border),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutStarts(),
    );
  }
}

class LayoutStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarDetailAnimation(),
        CustomBottomSheet(),
      ],
    );
  }
}

class CarDetailAnimation extends StatefulWidget {
  @override
  _CarDetailAnimationState createState() => _CarDetailAnimationState();
}

class _CarDetailAnimationState extends State<CarDetailAnimation> {
  @override
  Widget build(BuildContext context) {
    return CarDetails();
  }
}

class CarDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30),
            child: _carTitle(),
          ),
          Container(
            width: double.infinity,
            child: CarCarousel(),
          )
        ]));
  }
}

_carTitle() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 38),
            children: [
              TextSpan(text: currentCar.companyName),
              TextSpan(text: "\n"),
              TextSpan(
                  text: currentCar.carName,
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ]),
      ),
      SizedBox(height: 10),
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16),
          children: [
            TextSpan(
                text: currentCar.price.toString(),
                style: TextStyle(color: Colors.grey[20])),
            TextSpan(
              text: " / day",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    ],
  );
}

class CarCarousel extends StatefulWidget {
  @override
  _CarCarouselState createState() => _CarCarouselState();
}

class _CarCarouselState extends State<CarCarousel> {
  static final List<String> imgList = currentCar.imgList;
  final List<Widget> child = _map<Widget>(imgList, (index, String assetName) {
    return Container(
        child: Image.asset("assets/$assetName", fit: BoxFit.fitWidth));
  }).toList();
  static List<T> _map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // affichage des images
          CarouselSlider(
            height: 250,
            viewportFraction: 1.0,
            items: child,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _map<Widget>(imgList, (index, assetName) {
                  return Container(
                    //Barre
                    width: 50,
                    height: 2,
                    decoration: BoxDecoration(
                        color: _current == index
                            ? Colors.grey[100]
                            : Colors.grey[600]),
                  );
                }),
              ))
        ],
      ),
    );
  }
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  double sheetTop = 400;
  double minSheetTop = 30;

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: sheetTop,
      left: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded ? sheetTop = 400 : sheetTop = minSheetTop;
            isExpanded = !isExpanded;
          });
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    return Container(
        padding: EdgeInsets.only(top: 25),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            color: Color(0xfff1f1f1)),
        child: Column(
          children: <Widget>[
            drawerHandle(),
            Expanded(
                flex: 1,
                child: ListView(children: <Widget>[
                  offerDetails(sheetItemHeight),
                  // specification(sheetItemHeight),
                  // features(sheetItemHeight),
                  SizedBox(height: 220),
                ]))
          ],
        ));
  }
}

drawerHandle() {
  return Container(
    margin: EdgeInsets.only(bottom: 25),
    height: 3,
    width: 65,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
    ),
  );
}

offerDetails(double sheetItemHeight) {
  return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        children: <Widget>[
          Text(
            'offer Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 15),
              height: sheetItemHeight,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentCar.offerDetails.length,
                  itemBuilder: (context, index) {
                    return ListItem(
                      sheetItemHeight: sheetItemHeight,
                      mapVal: currentCar.offerDetails[index],
                    );
                  }))
        ],
      ));
}

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final Map mapVal;

  ListItem({this.sheetItemHeight, this.mapVal});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 20),
        width: sheetItemHeight,
        height: sheetItemHeight,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            mapVal.keys.elementAt(0),
            Text(mapVal.values.elementAt(0),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ))
          ],
        ));
  }
}
