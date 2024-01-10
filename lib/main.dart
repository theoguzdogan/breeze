//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  var url =
      "http://api.weatherapi.com/v1/forecast.json?key=fe3bb5aeabc148c8924143421241001&q=" +
          cityName +
          "&days=8";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    //print(jsonResponse);
    return jsonResponse;
  } else {
    //print('Request failed with status: ${response.statusCode}.');
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
    updateCityInfo(listItems[0]).then((_) {
      // setState to trigger a rebuild with the updated _city data
      setState(() {});
    });
  }

  Widget dayForecast(int dayDelta) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          (_city?.days?[dayDelta].weekday ?? ''),
          style: TextStyle(
            fontSize: 15,
            color: const Color.fromARGB(170, 255, 255, 255),
          ),
        ),
        const SizedBox(width: 16.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
                height: 35,
                width: 35,
                (_city?.days[dayDelta].condition_icon ?? '')),
            const SizedBox(width: 16.0),
          ],
        ),
        Text(
          'Yüksek: ' + (_city?.days?[dayDelta].max_c ?? '') + '°C',
          style: TextStyle(
            fontSize: 15,
            color: const Color.fromARGB(170, 255, 255, 255),
          ),
        ),
        const SizedBox(width: 16.0),
        Text(
          'Düşük: ' + (_city?.days?[dayDelta].min_c ?? '') + '°C',
          style: TextStyle(
            fontSize: 15,
            color: const Color.fromARGB(170, 255, 255, 255),
          ),
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }

  Widget hourForecast(int hourDelta) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10.0),
        Text(
          _city?.hours[hourDelta].hour.toString() ?? '',
          style: TextStyle(
              fontSize: 18, color: const Color.fromARGB(170, 255, 255, 255)),
        ),
        Image.network(
          height: 35,
          width: 35,
          _city?.hours[hourDelta].condition_icon ?? '',
        ),
        Text(
          (_city?.hours[hourDelta].temp_c.toString() ?? '') + '°C',
          style: TextStyle(
              fontSize: 14, color: const Color.fromARGB(170, 255, 255, 255)),
        ),
        const SizedBox(height: 10.0),
      ],
    );
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
                'Şehirler',
                style: TextStyle(
                  fontSize: 34,
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
                  child: Text("Şehir Ekle"),
                ),
                TextButton(
                  onPressed: () {
                    _clearCities();
                  },
                  child: Text("Temizle"),
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
                    _city?.name ?? '',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Text(
                    (_city?.region ?? '') + ', ' + (_city?.country ?? ''),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  FutureBuilder<String?>(
                    future: Future.value(_city?.condition_icon ?? null),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Return a placeholder or loading indicator while waiting for data
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle error state
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // If data is available, load the image using Image.network
                        return Image.network(
                          snapshot.data ??
                              'https://cdn.weatherapi.com/weather/64x64/day/116.png',
                        );
                      }
                    },
                  ),
                  Text(
                    ((_city?.temp_c) ?? '') + "°C",
                    //"Degree_Placeholder",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    ((_city?.localtime) ?? ''),
                    //"Degree_Placeholder",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
          title: Text("Yeni Şehir Ekle"),
          content: TextFormField(
            controller: newItemController,
            decoration: InputDecoration(labelText: "Şehir ismini giriniz:"),
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
              child: Text("Ekle"),
            ),
            TextButton(
              onPressed: () {
                newItemController.clear();
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  void _selectCity(String cityName) {
    setState(() {
      //_city = getCityInfo(cityName);

      updateCityInfo(cityName).then((_) {
        // setState to trigger a rebuild with the updated _city data
        setState(() {});
      });
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
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        hourForecast(0),
                        const SizedBox(width: 30.0),
                        hourForecast(1),
                        const SizedBox(width: 30.0),
                        hourForecast(2),
                        const SizedBox(width: 30.0),
                        hourForecast(3),
                        const SizedBox(width: 30.0),
                        hourForecast(4),
                        const SizedBox(width: 30.0),
                        hourForecast(5)
                      ],
                    )), //hour-forecast
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
                        child: Column(
                          children: [
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const SizedBox(width: 10.0),
                                Image.asset('assets/images/feelsLike.png',
                                    width: 20, height: 20),
                                const SizedBox(width: 7.0),
                                Text(
                                  "Hissedilen",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          170, 255, 255, 255)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              (_city?.feelslike_c ?? '') + '°C',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(170, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ), //FeelsLike
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: 87,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const SizedBox(width: 10.0),
                                Image.asset('assets/images/humidity.png',
                                    width: 20, height: 20),
                                const SizedBox(width: 7.0),
                                Text(
                                  "Nem",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          170, 255, 255, 255)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              (_city?.humidity ?? '') + '%',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(170, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ), //Humidity
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
                        child: Column(
                          children: [
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const SizedBox(width: 10.0),
                                Image.asset('assets/images/precipitation.png',
                                    width: 20, height: 20),
                                const SizedBox(width: 7.0),
                                Text(
                                  "Yağış",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          170, 255, 255, 255)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              (_city?.precipitation_mm ?? '') + 'mm',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(170, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ), //Precipitation
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: 87,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //const SizedBox(width: 27.0),
                                Text(
                                  'Y: ' + (_city?.max_c ?? '') + '°C',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          170, 255, 255, 255)),
                                ),
                                const SizedBox(width: 7.0),
                                Image.asset('assets/images/arrow_up.png',
                                    width: 15, height: 15),
                                const SizedBox(width: 7.0),
                                Image.asset('assets/images/arrow_down.png',
                                    width: 15, height: 15),
                                const SizedBox(width: 7.0),
                                Text(
                                  'D: ' + (_city?.min_c ?? '') + '°C',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          170, 255, 255, 255)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              _city?.condition_text ?? '',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(170, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ), //max-min, condition
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'GD: ' + (_city?.sunrise ?? ''),
                          style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(170, 255, 255, 255)),
                        ),
                        const SizedBox(width: 7.0),
                        Image.asset('assets/images/astroIcons.png',
                            width: 150, height: 20),
                        const SizedBox(width: 7.0),
                        Text(
                          'GB: ' + (_city?.sunset ?? ''),
                          style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(170, 255, 255, 255)),
                        ),
                      ],
                    )), //sunrise-sunset
                const SizedBox(height: 16.0),
                Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        dayForecast(0),
                        const SizedBox(height: 10.0),
                        dayForecast(1),
                        const SizedBox(height: 10.0),
                        dayForecast(2),
                        const SizedBox(height: 10.0),
                        dayForecast(3),
                        const SizedBox(height: 10.0),
                        dayForecast(4),
                        const SizedBox(height: 10.0),
                        dayForecast(5),
                        const SizedBox(height: 10.0),
                        dayForecast(6),
                        const SizedBox(height: 15.0),
                      ],
                    )), //day-forecast
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
