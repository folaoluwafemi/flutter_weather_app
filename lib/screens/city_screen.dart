import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/models.dart';
import 'package:flutter_weather_app/utils/util_methods.dart';

class CityScreen extends StatefulWidget {
  static const String id = '/city_screen';

  const CityScreen({Key? key}) : super(key: key);

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  bool onError = false;

  @override
  Widget build(BuildContext context) {
    String newCity = '';
    return SafeArea(
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/city_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: cityInputDecoration().copyWith(
                      hintText: 'Enter City Name',
                      hintStyle: TextStyle(
                        color: Colors.black54.withOpacity(0.4),
                      ),
                    ),
                    onChanged: (value) {
                      newCity = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextButton(
                  onPressed: () async {
                    print('new city: $newCity');
                    if (newCity == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Sorry I don't know the city \u{1f97a}"),
                        ),
                      );
                    } else {
                      Coordinate city =
                          await CoordinatesModel.fromCity(newCity);
                      setState(() {
                        onError = false;
                      });
                      print(city);
                      Navigator.of(context).pop(city);
                    }
                  },
                  child: const Text(
                    'Get Weather',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
