import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Sizedbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  double newtemp;
  String temp1;
  var _currentitemselected = "Mumbai";
  var city = ["Mumbai", "Pune", "Delhi"];
  Future getWeather() async {
    http.Response responce = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$_currentitemselected&appid=e060720c06febab8a044900eb9e73ce8");
    var results = jsonDecode(responce.body);
    setState(() {
      temp = results["main"]["temp"];
      this.newtemp = this.temp - 273.15;
      this.temp1 = this.newtemp.toString().substring(0, 5);
      this.description = results["weather"][0]["description"];
      this.currently = results["weather"][0]["main"];
      this.humidity = results["main"]["humidity"];
      this.windspeed = results["wind"]["speed"];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 38,
              width: SizeConfig.blockSizeHorizontal * 100,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    items: city.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newvalueselected) {
                      setState(() {
                        this._currentitemselected = newvalueselected;
                        this.getWeather();
                      });
                    },
                    value: _currentitemselected,
                  ),
                  Text(
                    "Currently in $_currentitemselected",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    temp1 != null ? temp1.toString() + "\u00B0" : "loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currently != null ? currently.toString() : "loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                      title: Text("Temprature"),
                      trailing: Text(
                        temp1 != null ? temp1.toString() + "\u00B0" : "loading",
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.cloud),
                      title: Text("Weather"),
                      trailing: Text(
                        description != null
                            ? description.toString()
                            : "loading",
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.sun),
                      title: Text("Humidity"),
                      trailing: Text(
                        humidity != null ? humidity.toString() : "loading",
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.wind),
                      title: Text("Wind speed"),
                      trailing: Text(
                        windspeed != null ? windspeed.toString() : "loading",
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
