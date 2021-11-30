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
      home: const StructPage(),
    );
  }
}

class _StructPageEvent extends ChangeNotifier {
  _StructPageEvent._();
  static _StructPageEvent? _intance;
  static _StructPageEvent get to => _intance ??= _StructPageEvent._();

  bool _isOpend = false;
  bool get isOpened => _isOpend;
  void openCloseDrawer(){
    _isOpend = !_isOpend;
    notifyListeners();
  }
}

class StructPage extends StatefulWidget {
  const StructPage({ Key? key }) : super(key: key);

  @override
  _StructPageState createState() => _StructPageState();
}

class _StructPageState extends State<StructPage> with SingleTickerProviderStateMixin  {
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
    _StructPageEvent.to.addListener(() {
      setState(() {
        if(_StructPageEvent.to.isOpened){
          controller.forward();
          drawerController?.forward();
          drawerListController?.forward();
        }else{
          controller.reverse();
          drawerController?.reverse();
          drawerListController?.reverse();
        }
      });
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
    var size = MediaQuery.of(context).size;
    var drawerWidth = size.width;
    if(rotate == null){
      rotate = Tween<double>(begin: 0.0, end: -30).animate(controller);
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
                  angle: rotate!.value/360,
                  child: Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.grey.shade400,
                    child: const HomePage()
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
                    child: Icon(_StructPageEvent.to.isOpened ? Icons.arrow_back : Icons.arrow_forward, color: Colors.white),
                  ),
                  onTap: (){
                    _StructPageEvent.to.openCloseDrawer();
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

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 25, bottom: 20),
            child: Text("Home", style: TextStyle(color: Colors.white)),
          ),
          Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.blue,
                width: MediaQuery.of(context).size.width/2- 32,
                height: 150,
              ),
              Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width/2- 32,
                height: 150,
              )
            ],
          )
        ],
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
  var listMenuItens = <_DrawerItemModel>[];
  var selectedIndex = 0;

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
    listMenuItens = [
      _DrawerItemModel(icon: const Icon(Icons.home, color: Colors.white),
        label: const Text("Home", style: TextStyle(fontSize: 18, color: Colors.grey))),
      _DrawerItemModel(icon: const Icon(Icons.dashboard, color: Colors.white),
        label: const Text("dashboard", style: TextStyle(fontSize: 18, color: Colors.grey))),
      _DrawerItemModel(icon: const Icon(Icons.calendar_today, color: Colors.white),
        label: const Text("Agenda", style: TextStyle(fontSize: 18, color: Colors.grey))),
      _DrawerItemModel(icon: const Icon(Icons.notifications, color: Colors.white),
        label: const Text("Notificações", style: TextStyle(fontSize: 18, color: Colors.grey))),
      _DrawerItemModel(icon: const Icon(Icons.settings, color: Colors.white),
        label: const Text("Configuração", style: TextStyle(fontSize: 18, color: Colors.grey)))
    ];
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
          const SizedBox(height: 35),
          if(listController.isCompleted)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: List.generate(listMenuItens.length, (index) {
                    var item = listMenuItens[index];
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedIndex = index;
                        });
                        Future.delayed(const Duration(milliseconds: 200), (){
                          _StructPageEvent.to.openCloseDrawer();
                        });
                      },
                      child: _DrawerItem(
                        selected: index == selectedIndex,
                        model: item,
                        millisecondsDelay: 50 * index,
                      ),
                    );
                  })
                ),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(CurvedAnimation(parent: controller, curve: Curves.elasticInOut)),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Sair", style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}

class _DrawerItemModel {
  final Widget icon;
  final Widget label;
  _DrawerItemModel({
    required this.icon,
    required this.label,
  });
}

class _DrawerItem extends StatefulWidget {
  final _DrawerItemModel model;
  final int millisecondsDelay;
  final bool selected;
  const _DrawerItem({
    Key? key,
    required this.model,
    required this.millisecondsDelay,
    required this.selected,
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Container(
          decoration: !widget.selected ? null :
            const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white, width: .3))
          ),
          child: Row(
            children: [
              widget.model.icon,
              const SizedBox(width: 5),
              widget.model.label,
            ],
          ),
        ),
      ),
    );
  }
}
