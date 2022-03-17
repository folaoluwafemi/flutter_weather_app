import 'package:geolocator/geolocator.dart';

Future getPosition() async {
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
  return Geolocator.getCurrentPosition();
}



Future<Position> getLastPosition() async {

  Position? location = await Geolocator.getLastKnownPosition();

  if(location != null){
    return location;
  }
  return Future.error('unknown last position');
}