import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  final int size;

  const Home({Key key, this.size = 16}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<IconData> icons = [
    Icons.whatshot,
    Icons.electric_bike,
    Icons.airplanemode_active_outlined,
    Icons.anchor,
    Icons.eco_sharp,
    Icons.tag_faces_sharp,
    Icons.attach_money,
    Icons.bolt,
  ];
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List data = [];
  int previousIndex;
  bool flip = false;
  int moves = 0, second = 0, minute = 0;
  Timer timer;

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        second = second + 1;
      });
      if (second == 60) {
        setState(() {
          second = 0;
          minute = minute + 1;
        });
      }
    });
  }

  resetAll() {
    timer.cancel();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Home(
                  size: 16,
                )),
        (Route<dynamic> route) => false);
  }

  Widget container(double width) {
    return Container(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              ],
            ),
            Text(
              "${moves.toString()} MOVES",
              style: GoogleFonts.poiretOne(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${minute.toString()} Mins ${second.toString()} Secs",
              style: GoogleFonts.poiretOne(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
                size: 25,
              ),
              onPressed: resetAll,
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      // data.add(i.toString());
      //  iconn.add(icons[i]);
      data.add(icons[i]);
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      // data.add(i.toString());
      // iconn.add(icons[i]);
      data.add(icons[i]);
    }

    startTimer();

    data.shuffle();
    // iconn.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/geo.png"), repeat: ImageRepeat.repeat),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 35, top: 30),
                    child: Text(
                      'Memory Game',
                      style: GoogleFonts.poiretOne(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 25),
                      child: LayoutBuilder(builder: (context, constraines) {
                        if (constraines.maxWidth > 1200) {
                          return container(
                              MediaQuery.of(context).size.width * .5);
                        }
                        return container(MediaQuery.of(context).size.width);
                      })),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 7,
                            //spreadRadius: 3,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Color(0xFF14BAB3), Color(0xFFA580CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                mainAxisExtent: 140,
                              ),
                              itemBuilder: (context, index) => FlipCard(
                                key: cardStateKeys[index],
                                onFlip: () async {
                                  if (!flip) {
                                    flip = true;
                                    previousIndex = index;
                                  } else {
                                    flip = false;
                                    if (previousIndex != index) {
                                      if (data[previousIndex] != data[index]) {
                                        cardStateKeys[previousIndex]
                                            .currentState
                                            .toggleCard();
                                        previousIndex = index;
                                        setState(() {
                                          ++moves;
                                        });
                                      } else {
                                        cardFlips[previousIndex] = false;
                                        cardFlips[index] = false;
                                        print(cardFlips);
                                        setState(() {
                                          ++moves;
                                        });
                                        if (cardFlips
                                            .every((t) => t == false)) {
                                          print("Won");
                                          showResult();
                                        }
                                      }
                                    }
                                  }
                                },
                                direction: FlipDirection.HORIZONTAL,
                                flipOnTouch: cardFlips[index],
                                front: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2E3D49),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin: EdgeInsets.all(4.0),
                                ),
                                back: Container(
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF02B3E4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      data[index],
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                              itemCount: data.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  TypewriterAnimatedTextKit(
                    textStyle: GoogleFonts.merienda(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      shadows: [
                        BoxShadow(
                          color: Color(0xFF2E3D49),
                          blurRadius: 3,
                        ),
                        BoxShadow(
                          color: Color(0xFFA580CC),
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    text: [
                      "Powered by : Omar Bakry",
                    ],
                  ),
                  Text(
                    "Natural Dart && Flutter code",
                    style: GoogleFonts.merienda(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      shadows: [
                        BoxShadow(
                          color: Color(0xFF2E3D49),
                          blurRadius: 3,
                        ),
                        BoxShadow(
                          color: Color(0xFFA580CC),
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Won!!!"),
        content: Text(
          "Time ${minute == 0 ? second : minute} ${minute == 0 ? "Second" : "Minute and $second Second"}\n${moves.toString()} moves",
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Home(
                            size: 16,
                          )),
                  (Route<dynamic> route) => false);
            },
            child: Text("Play again"),
          ),
        ],
      ),
    );
  }
}
