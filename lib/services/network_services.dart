import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = '421c144f1b0e8be2ba9c473f05cde42a';

dynamic getCity(city) async {
  String url =
      'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=421c144f1b0e8be2ba9c473f05cde42a';
  http.Response response = await http.get(Uri.parse(url));
  print('City getter status code: ${response.statusCode}');
  return jsonDecode(response.body);
}

dynamic getWeather() async {
  String lat = '4.63063063063063';
  String long = '7.953890530';
  String url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=421c144f1b0e8be2ba9c473f05cde42a&unit=metric';
  http.Response response = await http.get(Uri.parse(url));
  print('Weather getter status code: ${response.statusCode}');
  return jsonDecode(response.body) as Map;
}
