import 'package:basic_front/AddChild.dart';
import 'package:basic_front/Login.dart';
import 'package:basic_front/Volunteer/Volunteer_ProfileViewer.dart';
import 'package:flutter/material.dart';

import 'VolunteerCaptain_ProfileViewer.dart';
import 'VolunteerCaptain_VolunteerProfileViewer.dart';

class VolunteerCaptain_ActiveDashboard_Page extends StatefulWidget {
  VolunteerCaptain_ActiveDashboard_Page({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  VolunteerCaptain_ActiveDashboard_State createState() => VolunteerCaptain_ActiveDashboard_State();
}

abstract class ListItem {}

class Choice implements ListItem {

  String title;

  Choice (String title)
  {
    this.title = title;
  }
}

class Volunteer {
  String name;
  String route;

  Volunteer (String name, String route)
  {
    this.name = name;
    this.route = route;
  }
}

class VolunteerCaptain_ActiveDashboard_State extends State<VolunteerCaptain_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{

  final List<Tab> myTabs = <Tab>[
      Tab(text: 'Roster'),
      Tab(text: 'Volunteer List'),
    ];

    final items = List<String>.generate(50, (i) => "Item $i");
    List<String> names = ["Jacob Pfeiffer", "Marcus O'Real", "Kevin Augustus", "Stella Artois", "Guillaume Fuile", "Ruby Jack", "Lika Telova", "Rika Telova", "Vila Malie", "Marie Goodman"];
    List<Volunteer> volunteers;

    List<Volunteer> generateVolunteers() {
      List<Volunteer> volunteers = new List<Volunteer>();
      volunteers.add(new Volunteer("Richard Hemsworth", "Route 1"));
      volunteers.add(new Volunteer("Lexicon Grubert", "Route 3"));
      volunteers.add(new Volunteer("Tyrell Smith", "Route 2"));
      volunteers.add(new Volunteer("Alessa Tuford", "Route 3"));
      return volunteers;
    }

    final List<int> colorCodes = <int>[600, 500];

    TabController _tabController;

    @override
    void initState() {
      super.initState();
      _tabController = TabController(vsync: this, length: myTabs.length);
      volunteers = generateVolunteers();
    }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    void _select(Choice choice) {
      // Causes the app to rebuild with the new _selectedChoice.
    }

    List<PopupMenuItem<Choice>> ReturnDummyList ()
    {
      List<PopupMenuItem<Choice>> list = new List<PopupMenuItem<Choice>>();
      list.add(PopupMenuItem<Choice>(
        value: new Choice("View"),
        child: Text("View"),
      ));
      return list;
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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(title: 'Login')));
              },
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map((Tab tab) {
            if(tab.text == "Roster")
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>
                              [
                                Container(
                                  child: Text("Bus Route #3", textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 28, color: Colors.white),),
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(20)
                                    ),
                                  ),
                                  padding: EdgeInsets.all(20),
                                ),
                                Flexible(
                                  child: FlatButton(
                                    child: Text("Change Route"),
                                    onPressed: () => null,
                                  )
                                )
                              ]
                          ),
                        ),
                        margin: EdgeInsets.all(10),
                      ),
                      Container(
                        child: IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>
                              [
                                Container(
                                  child: Icon(
                                    Icons.search,
                                    size: 40,
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Flexible(
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    decoration: new InputDecoration(
                                      hintText: 'Search...',
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        borderSide: new BorderSide(
                                          color: Colors.black,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                Container(
                                    child: FlatButton(
                                        child: Text("Add Child"),
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddChildPage(title: 'Add Child')))
                                    )
                                )
                              ]
                          ),
                        ),
                        margin: EdgeInsets.only(left: 10, bottom: 10),
                      ),
                      Expanded(
                        child: new ListView.builder(
                          itemCount: names.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: ListTile(
                                title: Text('${names[index]}',
                                    style: TextStyle(color: Colors.white)),
                                trailing: PopupMenuButton<Choice>(
                                  onSelected: _select,
                                  itemBuilder: (BuildContext context) {
                                    return ReturnDummyList();
                                  },
                                ),
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ProfileViewer_Page(title: '${names[index]}')));
                                },
                                dense: false,
                              ),
                              color: Colors.blue[colorCodes[index%2]],
                            );
                          },
                        ),
                      ),
                    ],
                  )
              );
            else
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>
                              [
                                Container(
                                  child: Icon(
                                    Icons.search,
                                    size: 40,
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Flexible(
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    decoration: new InputDecoration(
                                      hintText: 'Search...',
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        borderSide: new BorderSide(
                                          color: Colors.black,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        margin: EdgeInsets.all(10),
                      ),
                      Expanded(
                        child: new ListView.builder(
                          itemCount: volunteers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: ListTile(
                                title: Text('${volunteers[index].name}',
                                style: TextStyle(color: Colors.white)),
                                trailing: Text('${volunteers[index].route}',
                                    style: TextStyle(color: Colors.white)),
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_VolunteerProfileViewer_Page(title: '${volunteers[index].name}')));
                                },
                                dense: false,
                              ),
                              color: Colors.blue[colorCodes[index%2]],
                            );
                          },
                        ),
                      ),
                    ],
                  )
              );
          }).toList(),
        ),
      );
  }
}














