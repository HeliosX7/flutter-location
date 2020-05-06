import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/models/location.dart';
import 'package:location/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Location> getLocation() async {
    final Geolocator geolocator = Geolocator()
      ..forceAndroidLocationManager = true;
    try {
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      try {
        List<Address> addresses = await Geocoder.local
            .findAddressesFromCoordinates(
                Coordinates(position.latitude, position.longitude));
        return Location(
            position.latitude,
            position.longitude,
            addresses.first.featureName,
            addresses.first.locality,
            addresses.first.adminArea,
            addresses.first.countryName);
      } catch (e) {
        print("geocoder error :" + e.toString());
        return null;
      }
    } catch (e) {
      print("geolocator error :" + e.toString());
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradDecoration,
        child: Center(
          child: FutureBuilder(
            future: this.getLocation(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ));
                default:
                  return snapshot.data == null
                      ? Container(
                          child: Center(
                            child: Text(
                              "Could not find your location.",
                              style: TextStyle(
                                  fontFamily: "Spartan",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : getLocationScreen(snapshot.data);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getLocationScreen(Location location) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Get Location.",
            style: TextStyle(
                fontFamily: "Spartan",
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Icon(
            Icons.location_on,
            size: 100,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Text(
            location.featureName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 30,
            ),
          ),
          Text(
            location.latitude.toStringAsFixed(2) +
                ", " +
                location.longitude.toStringAsFixed(2),
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            location.locality + ", " + location.adminArea,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(location.countryName),
        ],
      ),
    );
  }
}
