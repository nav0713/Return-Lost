import 'package:flutter/material.dart';
import 'package:returnlost/screens/recent_conversation.dart';
import 'package:returnlost/widgets/loading_screen.dart';
import './screens/home_page.dart';
import 'package:returnlost/screens/profile.dart';
import 'services/navigation_service.dart';
import './styles.dart';
import './screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.instance.navigatorKey,
      theme: ThemeData.light().copyWith(
          primaryTextTheme: TextTheme(
            caption: TextStyle(
                fontFamily: "OpenSans",
                color: Colors.black45,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
            // ignore: deprecated_member_use
            subhead: TextStyle(
                fontFamily: "OpenSans",
                fontSize: 20.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            display1: TextStyle(fontFamily: "OpenSans"),
            display2: TextStyle(
                fontFamily: "karla", fontSize: 14, color: Colors.black87),
          ),
          primaryColorBrightness: Brightness.dark,
          accentColor: Colors.cyanAccent,
          appBarTheme: AppBarTheme(color: redColor),
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        "login": (BuildContext context) => LoginWithProvider(),
        "home": (BuildContext context) => HomeWithProvider(),
        "profile": (BuildContext context) => Profile(),
        "loading": (BuildContext context) => LoadingScreen(),
        "recentChat" :(BuildContext context) => RecentConversation(),
      },
      home: LoginWithProvider(),
    );
  }
}
