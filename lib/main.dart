import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/screens/city_screen.dart';
import 'package:flutter_weather_app/screens/loading_screen.dart';
import 'package:flutter_weather_app/screens/location_screen.dart';
import 'package:flutter_weather_app/services/location_service.dart';

void main() async {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: CityScreen.id,
      onGenerateRoute: (settings) {
        if (settings.name == CityScreen.id) {
          return MaterialPageRoute(builder: (context) => const CityScreen());
        }
        else if (settings.name == LocationScreen.id) {
          return MaterialPageRoute(
              builder: (context) => const LocationScreen());
        }
        else if (settings.name == LoadingScreen.id) {
          return MaterialPageRoute(builder: (context) => const LoadingScreen());
        } else {
          return MaterialPageRoute(builder: (context) {
            return const SafeArea(
              child: Scaffold(
                body: Center(
                  child:
                      Text('Oopps...It seems you navigated to the wrong route'),
                ),
              ),
            );
          });
        }
      },
    );
  }
}
