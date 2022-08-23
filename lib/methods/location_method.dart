// ignore_for_file: avoid_print

import 'package:location/location.dart';

class LocationMethod {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionStatus;

  Future<LocationData> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
    }
    _permissionStatus = await location.hasPermission();

    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
    }
    LocationData locationData = await location.getLocation();
    print(" loc class lat ${locationData.latitude}");
    return locationData;
  }
}
