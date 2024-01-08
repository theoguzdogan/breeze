//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'city.dart';

void main() async {
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

Future<Map<String, dynamic>?> fetchWeatherData(String cityName) async {
  String apiURL =
      "api.weatherapi.com/v1/forecast.json?key=9804259f17b34b729aa213344232412&q=" +
          "London" +
          "&days=8";
  var url =
      "http://api.weatherapi.com/v1/forecast.json?key=9804259f17b34b729aa213344232412&q=" +
          cityName +
          "&days=8";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonResponse);
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listItems = ["New York", "London"];
  City? _city;

  Future<void> updateCityInfo(String cityName) async {
    var weatherDataJson = await fetchWeatherData(cityName);
    _city = City.fromJson(weatherDataJson);
  }

  TextEditingController newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateCityInfo(listItems[0]);
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
                    _city?.name ?? 'Unknown City',
                    //"Name_Placeholder",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Image.network(
                    "https://cdn.weatherapi.com/weather/64x64/day/116.png",
                  ),
                  Text(
                    ((_city?.temp_c) ?? "Unknown Degree") + "°C",
                    //"Degree_Placeholder",
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
      //_city = getCityInfo(cityName);

      updateCityInfo(cityName);
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
