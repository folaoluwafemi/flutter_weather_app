import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/models.dart';
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
  Map? weather;

  dynamic getWeatherMap() async {
    weather = await WeatherModel.instance.weather;
  }

  @override
  void initState() {
    getWeatherMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.location_on_outlined,
                          size: 50,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.location_city,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  padding: const EdgeInsets.only(left: 20),
                  child: FutureBuilder<Map>(
                      future: WeatherModel.instance.weather,
                      builder: (context, AsyncSnapshot<Map> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Text('Error');
                        }
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 30.0, top: 20,),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        Map map = snapshot.data!;

                        return Text(
                          '${map['temp'].toInt()}°\u{2601}',
                          style: const TextStyle(
                              fontSize: 70, fontWeight: FontWeight.bold),
                        );
                      }),
                ),
                const SizedBox(
                  height: 70,
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      print('getting position wait');
                      setState(() {
                        processing = true;
                      });
                      await getWeatherMap();
                      setState(() {
                        processing = false;
                      });
                      print(weather!['temp']);
                    },
                    child: const Text(
                      'Get location',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
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
