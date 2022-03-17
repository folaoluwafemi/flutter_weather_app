import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const apiKey = '421c144f1b0e8be2ba9c473f05cde42a';

class WeatherModel {
  int temperature = 0;

  WeatherModel._singletonConstructor();

  static WeatherModel instance = WeatherModel._singletonConstructor();

  Map? _weather = {};

  Future<Map> get weather async {
    if (_weather == null || _weather!.isEmpty) {
      _weather = await loadWeather();
      return _weather!;
    }
    _weather = await loadWeather();
    return _weather! ;
  }


  Future<Map> loadWeather() async {
    String lat = '4.63063063063063';
    String long = '7.953890530';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=421c144f1b0e8be2ba9c473f05cde42a&unit=metric';
    http.Response response = await http.get(Uri.parse(url));
    print('Weather getter status code: ${response.statusCode}');

    var json = jsonDecode(response.body);

    var temp = json['main']['temp'] - 273 as double;
    var humidity = json['main']['humidity'] as int;
    temperature = temp.toInt();
    return Map.of({
      'temp': temp,
      'humidity': humidity,
    });
  }
}

class CoordinatesModel {
  final String city = 'Eket';

  CoordinatesModel._singletonConstructor();

  static CoordinatesModel instance = CoordinatesModel._singletonConstructor();

  static double? latitude;
  static double? longitude;

  Map<String, double?>? coordinates;

  dynamic get coordinate async {
    if (coordinates == null || coordinates!.isEmpty) {
      var coordinates = await getLastPosition();
      return coordinates;
    }
    return coordinates!;
  }

  Future getDevicePosition() async {
    bool permitted;
    LocationPermission locationPermission;

    permitted = await Geolocator.isLocationServiceEnabled();
    if (!permitted) {
      await Geolocator.requestPermission();
      // return Future.error(
      //     'You have denied this app permission to access your location');
    }
    locationPermission = await Geolocator.checkPermission();
    print('checking permission');

    if (locationPermission == LocationPermission.denied) {
      print('checking permission in permission checking');
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions have been denied by user');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('User has denied access to location Forever');
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;
    return Map.of({
      'lat': latitude,
      'long': longitude,
    });
  }

  Future getLastPosition() async {
    Position? location = await Geolocator.getLastKnownPosition();

    if (location != null) {
      longitude = location.longitude;
      latitude = location.latitude;

      return Map.of({
        'lat': latitude,
        'long': longitude,
      });
    }
    return Future.error('unknown last position');
  }

  static dynamic fromCity(String newCity) async {
    String url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$newCity&appid=421c144f1b0e8be2ba9c473f05cde42a';
    http.Response response = await http.get(Uri.parse(url));
    print('City getter status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List<Map>;
      latitude = json[0]['lat'];
      longitude = json[0]['lon'];
      return Map.from({
        'lat': latitude,
        'long': longitude,
      });
    }
    return jsonDecode(response.body);
  }
}
