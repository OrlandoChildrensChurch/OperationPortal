import 'package:basic_front/DashboardActive.dart';
import 'package:flutter/material.dart';

class DashboardInactivePage extends StatefulWidget {
  DashboardInactivePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  DashboardInactiveState createState() => DashboardInactiveState();
}

class DashboardInactiveState extends State<DashboardInactivePage>
{
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              child: Image(
                  image: AssetImage('assets/OCC_LOGO_128_128.png')
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                    new Radius.circular(20)
                ),
              ),
              height: 200,
              width: 200,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 5),
            ),

            Container(
              child: Text("Mark Hamilton", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, color: Colors.white),),
              decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.all(
                    new Radius.circular(20)
                ),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 20, bottom: 5),
            ),

            Container (
              child: FlatButton(
                child: const Text('Present QR Code', style: TextStyle(fontSize: 24)),
                onPressed: ()
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardActivePage(title: 'Dashboard')));
                },
              ),
              decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.all(
                    new Radius.circular(20)
                ),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20, bottom: 5),
            ),

            Container(
              child: Text("Please present your QR code to staff in-order to begin volunteering.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, color: Colors.blue)),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                    new Radius.circular(20)
                ),
              ),
              width: 250,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top: 20, bottom: 5),
            ),
          ],
        ),
      ),
    );
  }
}