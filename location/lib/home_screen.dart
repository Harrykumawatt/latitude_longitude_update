// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with WidgetsBindingObserver {
//   bool serviceStatus = false;
//   bool haspermission = true;
//   late LocationPermission permission;
//   late Position position;
//   String long = "", lat = "";
//   bool flag = false;
//   late StreamSubscription<Position> positionStream;
//   @override
//   void initState() {
//     checkGps();
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   // @override
//   // void initState() {
//   //   checkGps();
//   //   super.initState();
//   // }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // super.didChangeAppLifecycleState(state);

//     if (state == AppLifecycleState.resumed && flag) {
//       setState(() {
//         flag = true;
//       });
//       getLocation();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("location"),
//       ),
//       body: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(50),
//         child: Column(
//           children: [
//             Text(serviceStatus ? "GPS is Enabled" : "GPS is disabled."),
//             Text(haspermission ? "GPS is Enabled" : "GPS is disabled"),
//             Text("Longitude: $long", style: TextStyle(fontSize: 20)),
//             Text(
//               "latitude: $lat",
//               style: TextStyle(fontSize: 20),
//             ),
//             Expanded(
//                 child: ListView.builder(
//                 itemCount: ,  
//               itemBuilder: (context, index) {

//               },
//             ))
//           ],
//         ),
//       ),
//     );
//   }

//   checkGps() async {
//     serviceStatus = await Geolocator.isLocationServiceEnabled();
//     if (serviceStatus) {
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           print("Location permission are denied");
//         } else if (permission == LocationPermission.deniedForever) {
//           setState(() {
//             flag = true;

//             openAppSettings();
//           });
//         } else {
//           haspermission = true;
//         }
//       } else {
//         haspermission = true;
//       }
//       if (haspermission) {
//         setState(() {});
//         getLocation();
//       }
//     } else {
//       print("GPS Service is not enabled, turn o GPS location");
//     }
//     setState(() {});
//   }

//   getLocation() async {
//     position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print(position.longitude);
//     print(position.latitude);

//     long = position.longitude.toString();
//     lat = position.latitude.toString();
//     setState(() {});
//     LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//     );
//     StreamSubscription<Position> positionStream =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position position) {
//       print(position.longitude);
//       print(position.latitude);

//       long = position.longitude.toString();
//       lat = position.latitude.toString();
//       final LocationSettings locationSettings = LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 100,
//           timeLimit: Duration(seconds: 0));
//     });
//   }
// }
