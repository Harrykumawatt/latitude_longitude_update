import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:location/model.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool serviceStatus = false;
  bool haspermission = true;
  List<Position> locationlist = [];
  LocationPermission? permission;
  Position? startPosition, endPosition;

  bool flag = false;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && flag) {
      setState(() {
        flag = true;
      });
      getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("location"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(serviceStatus ? "GPS is Enabled" : "GPS is disabled."),
            SizedBox(
              height: 20,
            ),
            Text(haspermission ? "Has Permisstion" : "Denied Permisstion"),
            SizedBox(
              height: 20,
            ),
            Text(startPosition != null
                ? "Start latitude: ${startPosition!.latitude} Longitude: ${startPosition!.longitude}"
                : ""),
            SizedBox(
              height: 20,
            ),
            Text(endPosition != null
                ? "End latitude: ${endPosition!.latitude} Longitude: ${endPosition!.longitude}"
                : ""),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      checkGps();
                    },
                    child: Text("Sart")),
                ElevatedButton(
                    onPressed: () {
                      if (positionStream != null) {
                        positionStream!.cancel();
                      }
                      setState(() {
                        if (locationlist.isNotEmpty) {
                          endPosition = locationlist.last;
                        }
                      });
                    },
                    child: Text("Stop")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        startPosition = null;
                        endPosition = null;
                        locationlist.clear();
                      });
                    },
                    child: Text("Clear List")),
              ],
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: locationlist.length,
              itemBuilder: (context, index) {
                Position item = locationlist[index];
                return ListTile(
                  leading: Text(item.latitude.toString()),
                  trailing: Text(item.longitude.toString()),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  checkGps() async {
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (serviceStatus) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission are denied");
        } else if (permission == LocationPermission.deniedForever) {
          setState(() {
            flag = true;

            openAppSettings();
          });
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        setState(() {});
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn o GPS location");
    }
    setState(() {});
  }

  getLocation() async {
    startPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {});

    const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 10));
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print("Stream :- " + position.longitude.toString());

      print("Stream :- " + position.latitude.toString());

      setState(() {
        locationlist.add(position);
        print("Location Length : ${locationlist.length}");
      });
    });
  }
}
