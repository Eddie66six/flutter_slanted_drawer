import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin  {
  bool isOpend = false;
  late AnimationController controller;
  Animation<double>? rotate;
  Animation<double>? pageLeftMargin;
  Animation<double>? pageTopMargin;
  Animation<double>? drawerMargin;
  Animation<double>? arrowMargin;

   @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    controller.addListener(() {setState(() {});});
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var drawerWidth = size.width;
    if(rotate == null){
      rotate = Tween<double>(begin: 1.0, end: 0.98).animate(controller);
      pageLeftMargin = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
      pageTopMargin = Tween<double>(begin: 0.0, end: 80).animate(controller);
      drawerMargin = Tween<double>(begin: -drawerWidth, end: 0.0).animate(controller);
      arrowMargin = Tween<double>(begin: 0, end: drawerWidth-54).animate(controller);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              //drawer
              Positioned(
                top: 0,
                left: drawerMargin!.value,
                child: DrawerWidget(drawerWidth: drawerWidth),
              ),
              //page/body
              Positioned(
                top: pageTopMargin!.value,
                left: (drawerWidth * 0.6 + 30) * pageLeftMargin!.value,
                child: Transform.rotate(
                  angle: -pi / rotate!.value,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.grey,
                  ),
                ),
              ),
              //arrow
              Positioned(
                top: 0,
                left: arrowMargin!.value,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(isOpend ? Icons.arrow_back : Icons.arrow_forward, color: Colors.white),
                  ),
                  onTap: (){
                    setState(() {
                      isOpend = !isOpend;
                      if(isOpend){
                        controller.forward();
                      }else{
                        controller.reverse();
                      }
                    });
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class DrawerWidget extends StatefulWidget {
  final double drawerWidth;
  const DrawerWidget({
    Key? key,
    required this.drawerWidth,
  }) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: widget.drawerWidth,
        color: Colors.blueGrey,
    );
  }
}