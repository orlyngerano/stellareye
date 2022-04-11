import 'package:flutter/material.dart';
import 'package:stellareye/views/gallery_view.dart';
import 'package:stellareye/views/media_view.dart';
import 'package:stellareye/views/video_view.dart';

import 'models/media.dart';

void main() {
  runApp(StettelarEye());
}

class StettelarEye extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stellar Eye',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              titleTextStyle: TextStyle(color: Colors.black))),
      home: Gallery(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Video.routeName:
            final videoSource = settings.arguments as String;

            return MaterialPageRoute(
              builder: (context) {
                return Video(videoSource);
              },
            );
          case Media.routeName:
            final item = settings.arguments as Item;

            return MaterialPageRoute(
              builder: (context) {
                return Media(item);
              },
            );
          default:
            assert(false, 'Need to implement ${settings.name}');
            return null;
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Gallery(),
      );
}
