import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/models.dart';
import 'package:flutter_weather_app/screens/city_screen.dart';
import 'package:flutter_weather_app/utils/weather_messages.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LocationScreen extends StatefulWidget {
  static const String id = '/location_screen';

  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int celsiusTemp = 9;
  bool processing = false;
  Coordinate weatherCoordinates = Coordinate(
    latitude: 4.63063063063063,
    longitude: 7.953890530,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: processing,
            progressIndicator: const CircularProgressIndicator(
              color: Colors.white,
            ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/location_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              weatherCoordinates = Coordinate(
                                latitude: 4.63063063063063,
                                longitude: 7.953890530,
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 50,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () async {
                            Coordinate? newCoordinates =
                                await Navigator.of(context)
                                    .pushNamed(CityScreen.id) as Coordinate?;
                            if (newCoordinates != null) {
                              setState(() {
                                weatherCoordinates = newCoordinates;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.location_city,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<Map>(
                    future: WeatherModel.instance
                        .fromCoordinate(weatherCoordinates),
                    builder: (context, AsyncSnapshot<Map> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Padding(
                          padding: EdgeInsets.only(top: 80.0),
                          child: Center(
                            child: Text(
                              'Turn On your data',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.only(
                            left: 50.0,
                            top: 120,
                          ),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      Map map = snapshot.data!;
                      int temp = map[WeatherModel.tempKey];
                      int condition = map[WeatherModel.conditionKey];
                      String city = map[WeatherModel.cityNameKey];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 100),
                            padding: const EdgeInsets.only(left: 20),
                            width: constraints.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Weather in $city',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '$temp° ${WeatherMessageModel.getWeatherIcon(condition)}',
                                  style: const TextStyle(
                                      fontSize: 70,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 170,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0.0,
                              top: 50,
                            ),
                            child: Center(
                              child: Text(
                                WeatherMessageModel.getMessage(temp),
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
