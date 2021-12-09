import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantqr/page/qr_scan_page.dart';

import 'utlity_components/svg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCode = '';
  Widget _header() {
    return Container(
      color: Color(0xFF55ABFB),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        children: [
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                  opacity: 0.5,
                  child: Text(
                    'QR Plant',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )),
              const SizedBox(height: 10),
              Text(
                'Mark',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Spacer(),
//        GestureDetector(
//          onTap: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => ProfileHome(),
//                ));
//          },
//          child:
//          Container(
//            width: 50,
//            height: 50,
//            padding: EdgeInsets.all(12.0),
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(50.0),
//              border: Border.all(
//                color: Color(0xff313D56).withOpacity(0.4),
//                width: 0.5,
//              ),
//            ),
////            child: SvgPicture.asset(SvgIcons.grid),
//          ),
//        )
        ],
      ),
    );
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: DataSearch());
          },
          child: TextFormField(
            enabled: false,
            decoration: new InputDecoration(
              filled: true,
              hintStyle: TextStyle(
                color: Color(0xFFD6D8DD),
                fontSize: 18,
              ),
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintText: "Search ...",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(SvgIcons.search),
              ),
              isDense: true,
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Color(0xFFD6D8DD),
                  )),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(top: 110),
              child: Container(
//                              height: MediaQuery.of(context).size.height / 14.5,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20.0,
                            // shadow
                            spreadRadius: .8,
                            // set effect of extending the shadow
                          )
                        ],
                      ),
                      child: _search()))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => QRScanPage(),
                        )),
                    child: Container(
                        padding: EdgeInsets.all(50),
                        child: Image(
                          image: AssetImage('assets/images/qr.png'),
                        ))),
//              ButtonWidget(
//                text: 'Create QR Code',
//                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => QRCreatePage(),
//                )),
//              ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ))));


  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}

@override
double get maxExtent => 180;

@override
double get minExtent => 180;

@override
bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
  return false;
}

class DataSearch extends SearchDelegate<String> {
  final therapists = [
    "Snake Plant",
    "Peace Lily",
    "Lucky bamboo plant",
    "Ferns",
    "Aloe vera",
    "Grape Ivy",
  ];
  final recentTherapists = [
    "Snake Plant",
    "Peace Lily",
    "Lucky bamboo plant",
    "Ferns",
    "Aloe vera",
    "Grape Ivy",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? recentTherapists
        : therapists.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            showResults(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScanPage(),
                ));
          },
//          leading: Icon(Icons.add_comment),
          title: RichText(
            text: TextSpan(
                text: suggestions[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                      text: suggestions[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]),
          )),
      itemCount: suggestions.length,
    );
  }
}

class CustomToolbarShape extends CustomPainter {
  final Color lineColor;

  const CustomToolbarShape({this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

//First oval
    Path path = Path();
    Rect pathGradientRect = new Rect.fromCircle(
      center: new Offset(size.width / 4, 0),
      radius: size.width / 1.4,
    );

    Gradient gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(110, 158, 255, 1).withOpacity(1),
        Color.fromRGBO(0, 85, 255, 1).withOpacity(1),
      ],
      stops: [
        0.3,
        1.0,
      ],
    );

    path.lineTo(-size.width / 1.4, 0);
    path.quadraticBezierTo(
        size.width / 2, size.height * 2, size.width + size.width / 1.4, 0);

    paint.color = Colors.blueAccent;
    paint.shader = gradient.createShader(pathGradientRect);
    paint.strokeWidth = 40;
    path.close();

    canvas.drawPath(path, paint);

//Second oval
    Rect secondOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 1.5),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(225, 255, 255, 1).withOpacity(0.1),
        Color.fromRGBO(0, 171, 255, 1).withOpacity(0.2),
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    Paint secondOvalPaint = Paint()
      ..color = Colors.blueAccent
      ..shader = gradient.createShader(secondOvalRect);

    canvas.drawOval(secondOvalRect, secondOvalPaint);

//Third oval
    Rect thirdOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 2.7),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(225, 255, 255, 1).withOpacity(0.05),
        Color.fromRGBO(0, 170, 255, 1).withOpacity(0.2),
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    Paint thirdOvalPaint = Paint()
      ..color = Colors.blueAccent
      ..shader = gradient.createShader(thirdOvalRect);

    canvas.drawOval(thirdOvalRect, thirdOvalPaint);

//Fourth oval
    Rect fourthOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.4, -size.width / 1.875),
      Offset(size.width / 1.34, size.height / 1.14),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(225, 255, 255, 1).withOpacity(0.05),
        Color.fromRGBO(0, 196, 255, 1).withOpacity(0.3),
      ],
      stops: [
        0.3,
        1.0,
      ],
    );
    Paint fourthOvalPaint = Paint()
      ..color = Colors.blueAccent
      ..shader = gradient.createShader(fourthOvalRect);

    canvas.drawOval(fourthOvalRect, fourthOvalPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}
