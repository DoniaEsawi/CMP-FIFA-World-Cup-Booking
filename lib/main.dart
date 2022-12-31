import 'dart:developer';

import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/admin.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/providers/user/match_provider.dart';
import 'package:fifa2022/providers/user/stadium_provider.dart';
import 'package:fifa2022/providers/user/ticket_provider.dart';
import 'package:fifa2022/router/fluru.dart';
import 'package:fifa2022/screens/admin_panel/admin_login.dart';
import 'package:fifa2022/screens/home/home_screen.dart';
import 'package:fifa2022/screens/home/temp_screen.dart';
import 'package:fifa2022/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/user/user_provider.dart';

void main() async{

  SharedPreferences prefs =await SharedPreferences.getInstance();
  FluroRouterMain.setupRouter();

  if(prefs.getBool("admin_logged_in")!=null &&prefs.getBool("admin_logged_in")==true)
    {
      AdminModel.token=prefs.getString("admin_token");
      AdminModel.adminName=prefs.getString("admin_name");
    }
  var token=prefs.getString("token");
  if(token!=null) {

    await getUserInfo(token.toString());
    if(Globals.isLoggedIn)
      {
        Globals.token=token;

      }
  }
  else{
    Globals.isLoggedIn=false;

  }
  log("is logged in: ${Globals.isLoggedIn}");
  log("is logged in: ${Globals.isManager}");
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MyApp());
}



Future<void> getUserInfo(String token)async{
  try {
    var userData = await AuthService().getUserInfo(token);
    Globals.isManager=User.fromJson(userData).role=="manager";
    Globals.isLoggedIn= true; // user exists

  }
  catch (e)
  {
    log(e.toString());
    Globals.isLoggedIn= false; // user deleted, or token is expired
  }}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(), ),
        ChangeNotifierProvider(create: (context) => MatchProvider(), ),
        ChangeNotifierProvider(create: (context) => StadiumProvider(), ),
        ChangeNotifierProvider(create: (context) => TicketProvider(), ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: mainRed
        ),
          initialRoute: "home",
          onGenerateRoute: FluroRouterMain.router.generator,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
