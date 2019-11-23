import 'package:animal_shogi_flutter/Shogi.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '動物将棋',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: "NotoSansJP",
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Text("動物将棋", style: TextStyle(fontSize: 50),),
            ),
            RaisedButton(
              child: Text("Play"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/home/play"),
                        builder: (BuildContext context) => PlayPage()
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
