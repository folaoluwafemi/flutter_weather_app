import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const apiKey = '421c144f1b0e8be2ba9c473f05cde42a';

class WeatherModel {
  int temperature = 0;
  static String tempKey = 'temperature';
  static String conditionKey = 'condition';
  static String humidityKey = 'humidity';
  static String cityNameKey = 'cityName';

  WeatherModel._singletonConstructor();

  static WeatherModel instance = WeatherModel._singletonConstructor();

  Map? _weather = {};

  Future<Map> get weather async {
    if (_weather == null || _weather!.isEmpty) {
      _weather = await loadWeather();
      return _weather!;
    }
    _weather = await loadWeather();
    return _weather!;
  }

  Future<Map> loadWeather() async {
    double lat = 4.63063063063063;
    double long = 7.953890530;

    http.Response response =
        await _getWeather(Coordinate(latitude: lat, longitude: long));

    var json = jsonDecode(response.body);

    var temp = (json['main']['temp'] - 273 as double).toInt();
    var humidity = json['main']['humidity'] as int;
    var cityName = json['name'] as String;
    int condition = json['weather'][0]['id'];
    temperature = temp.toInt();
    return Map.of({
      tempKey: temp,
      humidityKey: humidity,
      conditionKey: condition,
      cityNameKey: cityName,
    });
  }

  Future<Map> fromCoordinate(Coordinate coordinate) async {
    http.Response response = await _getWeather(Coordinate(
        latitude: coordinate.latitude, longitude: coordinate.longitude));

    var json = jsonDecode(response.body);

    var temp = (json['main']['temp'] - 273 as double).toInt();
    var humidity = json['main']['humidity'] as int;
    var cityName = json['name'] as String;
    int condition = json['weather'][0]['id'];
    temperature = temp.toInt();
    return Map.of({
      tempKey: temp,
      humidityKey: humidity,
      conditionKey: condition,
      cityNameKey: cityName,
    });
  }
}

Future<http.Response> _getWeather(Coordinate coordinates) async {
  String url =
      'https://api.openweathermap.org/data/2.5/weather?lat=${coordinates.latitude}&lon=${coordinates.longitude}&appid=421c144f1b0e8be2ba9c473f05cde42a&unit=metric';
  http.Response response = await http.get(Uri.parse(url));
  print('Weather getter status code: ${response.statusCode}');
  return response;
}

class CoordinatesModel {
  final String city = 'Eket';

  CoordinatesModel._singletonConstructor();

  static CoordinatesModel instance = CoordinatesModel._singletonConstructor();
  double? latitude;
  double? longitude;

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
    return Coordinate(latitude: latitude!, longitude: longitude!);
  }

  Future getLastPosition() async {
    Position? location = await Geolocator.getLastKnownPosition();

    if (location != null) {
      longitude = location.longitude;
      latitude = location.latitude;

      return Coordinate(latitude: latitude!, longitude: longitude!);
    }
    return Future.error('unknown last position');
  }

  static Future<Coordinate> fromCity(String newCity) async {
    http.Response response = await getCity(newCity);
    if (response.statusCode >= 400 && response.statusCode < 500) {
      return Future.error('unable to retrieve data');
    }
    var json = jsonDecode(response.body) as List;
    double latitude = json[0]['lat'];
    double longitude = json[0]['lon'];
    return Coordinate(latitude: latitude, longitude: longitude);
  }
}

class Coordinate {
  double latitude;
  double longitude;

  Coordinate({
    required this.latitude,
    required this.longitude,
  });

  Coordinate get coordinate {
    return Coordinate(latitude: latitude, longitude: longitude);
  }

  void set(Coordinate newCoordinates) {
    latitude = newCoordinates.latitude;
    longitude = newCoordinates.longitude;
  }

  @override
  String toString() {
    return 'latitude: $latitude\nlongitude: $longitude';
  }
}

Future<http.Response> getCity(city) async {
  String url =
      'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=421c144f1b0e8be2ba9c473f05cde42a';
  http.Response response = await http.get(Uri.parse(url));
  return response;
}
