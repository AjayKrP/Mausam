import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weather_app/bloc/weather_helper.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mausam',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeatherModel weatherModel;
  String city;
  TextEditingController nameController = TextEditingController();
  WeatherHelper _weatherHelper = new WeatherHelper();

  @override
  void initState() {
    super.initState();
  }

  getWeatherInfo() async{
    print(_weatherHelper.urlBuilder(city));
    var res = await http.get(_weatherHelper.urlBuilder(city == null ? Config.DEFAULT_CITY : nameController.text));
    var json = jsonDecode(res.body);
    setState(() {
      weatherModel = WeatherModel.fromJson(json);
    });
  }

  getOptions(Color color, var weatherObj) {
    return Container(
      height: 50.0,
      child: ListView.builder(
          itemCount: weatherObj.values.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return FilterChip(
              backgroundColor: color,
              label: Text('${weatherObj.keys.toList()[index].toString()}: ' + weatherObj.values.toList()[index].toString()),
              onSelected: (b){},
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Mausam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter City',
                    ),
                  ),
                ),
                Container(
                  child: FloatingActionButton(
                    child: Text('Search'),
                    onPressed: () {
                      if (nameController.text != "") {
                        getWeatherInfo();
                      }
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: weatherModel == null ? Center(
                child: Text('Enter city name and get details'),
              ) : Column(
                children: [
                  Text(weatherModel.name,  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),),
                  Text('Co-ordinate', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),),
                  getOptions(Colors.yellow, weatherModel.coord.toJson()),
                  Text(weatherModel.weather[0].main),
                  Text(weatherModel.weather[0].description),
                  Text('Main', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),),
                  getOptions(Colors.cyan, weatherModel.main.toJson()),
                  Text('Sys', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),),
                  getOptions(Colors.black12, weatherModel.sys.toJson()),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
