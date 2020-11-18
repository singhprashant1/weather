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
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;

  Future getWeather() async {
    http.Response responce = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=Mumbai&appid=e060720c06febab8a044900eb9e73ce8");
    var results = jsonDecode(responce.body);
    setState(() {
      this.temp = results["main"]["temp"];
      this.description = results["weather"][0]["description"];
      this.currently = results["weather"][0]["main"];
      this.humidity = results["main"]["humidity"];
      this.windspeed = results["wind"]["speed"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
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
                  Text(
                    "Currently in mumbai",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    temp != null ? temp.toString() + "\u00B0" : "loading",
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
                        temp != null ? temp.toString() + "\u00B0" : "loading",
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
