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
  AnimationController? drawerController;
  AnimationController? drawerListController;
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
                child: DrawerWidget(drawerWidth: drawerWidth,
                callbackOnInit: (dc, dcl) {
                  drawerController = dc;
                  drawerListController = dcl;
                }),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Icon(isOpend ? Icons.arrow_back : Icons.arrow_forward, color: Colors.white),
                  ),
                  onTap: (){
                    setState(() {
                      isOpend = !isOpend;
                      if(isOpend){
                        controller.forward();
                        drawerController?.forward();
                        drawerListController?.forward();
                      }else{
                        controller.reverse();
                        drawerController?.reverse();
                        drawerListController?.reverse();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class DrawerWidget extends StatefulWidget {
  final double drawerWidth;
  final Function(AnimationController, AnimationController) callbackOnInit;
  const DrawerWidget({
    Key? key,
    required this.drawerWidth,
    required this.callbackOnInit,
  }) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController listController;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    listController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    controller.addListener(() {setState(() {});});
    widget.callbackOnInit(controller, listController);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: MediaQuery.of(context).size.height,
      width: widget.drawerWidth,
      color: Colors.blueGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(controller),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text("Guilherme",
                      style: TextStyle(fontSize: 18, 
                        fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(" "),
                    Text("Rodrigues",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
                const Text("Gerente seila do que",
                  style: TextStyle(fontSize: 10, color: Colors.grey))
              ],
            ),
          ),
          const SizedBox(height: 30),
          if(listController.isCompleted)
          Column(
            children: List.generate(5, (index) {
              return _DrawerItem(
                icon: const Icon(Icons.ac_unit),
                label: Text("hhh $index"),
                millisecondsDelay: 150 * index,
              );
            })
          )
        ]
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  final Widget icon;
  final Widget label;
  final int millisecondsDelay;
  const _DrawerItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.millisecondsDelay,
  }) : super(key: key);

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    controller.addListener(() {setState(() {});});
    Future.delayed(Duration(milliseconds: widget.millisecondsDelay), (){
      controller.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(controller),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            widget.icon,
            const SizedBox(width: 5),
            widget.label
          ],
        ),
      ),
    );
  }
}
