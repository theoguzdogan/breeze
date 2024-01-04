import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breeze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class City {
  String name;
  double degreeC;
  String logo;

  City(this.name, this.degreeC, this.logo);
}

City getCityInfo(String cityName) {
  String _name = cityName;
  double _degreeC = 22.0;
  String _logo = "https://cdn.weatherapi.com/weather/64x64/day/116.png";
  return City(_name, _degreeC, _logo);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listItems = ["New York", "London"];
  City _city = getCityInfo("");

  TextEditingController newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _city = getCityInfo(listItems[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breeze'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2997FC),
                    Color(0xFFA8D5FF),
                  ],
                ),
              ),
              child: Text(
                'Cities',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _showNewItemDialog(context);
                  },
                  child: Text("Add City"),
                ),
                TextButton(
                  onPressed: () {
                    _clearCities();
                  },
                  child: Text("Clear Cities"),
                )
              ],
            ),
            // Display the list items
            for (String item in listItems)
              ListTile(
                title: Text(item),
                onTap: () {
                  _selectCity(item);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Detect swipe-up gesture
          if (details.primaryDelta! < -20) {
            // Show the menu when swipe-up is detected
            showSwipeUpMenu(context);
          }
        },
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2997FC),
                  Color(0xFFA8D5FF),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _city.name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Image.network(
                    "https://cdn.weatherapi.com/weather/64x64/day/116.png",
                  ),
                  Text(
                    _city.degreeC.toString() + "°C",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNewItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New City"),
          content: TextFormField(
            controller: newItemController,
            decoration: InputDecoration(labelText: "Enter City Name"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  listItems.add(newItemController.text);
                });
                newItemController.clear();
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                newItemController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _selectCity(String cityName) {
    setState(() {
      _city = getCityInfo(cityName);
    });
  }

  void _clearCities() {
    setState(() {
      listItems.clear();
    });
  }

  void showSwipeUpMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for full height based on content
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

        return Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 58,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 87,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 87,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: 87,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 87,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: 87,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 298,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
