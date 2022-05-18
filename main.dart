import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'scraping.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

const LatLng urawasutaba =
LatLng(35.8586507,139.6567354);
//35.8586507,139.6567354


Set<Marker> _createMarker() {
  // BitmapDescriptor customIcon;
  // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
  //     'assets/images/car-icon.png')
  //     .then((d) {
  //   customIcon = d;
  // });
  return {
    Marker(
      markerId: MarkerId("marker_1"),
      position: urawasutaba,
      infoWindow: InfoWindow(title:"浦和 蔦屋書店",snippet: "WiFi○ 電源○")

    ),
  };
}


// make sure to initialize before map loading
// BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
// 'assets/images/car-icon.png')
//     .then((d) {
// customIcon = d;
// });

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;
  late StreamSubscription<Position> positionStream;

  // final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  final LocationSettings locationSettings = const LocationSettings(
    distanceFilter: 100,
  );

  late LatLng _initialPosition;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();

    //位置情報が許可されていない時に許可をリクエストする
    Future(() async {
      LocationPermission permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        await Geolocator.requestPermission();
      }
    });

    //現在位置を更新し続ける
    // positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position? position) {
    //       currentPosition = position;
    //       _initialPosition = LatLng(position.latitude, position.longitude);
    //       print(position == null
    //           ? 'Unknown'
    //           : '${position.latitude.toString()}, ${position.longitude.toString()}');
    //     });
  }
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
      print(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: const Text('Cafe_map'),
          backgroundColor: Colors.brown,
        ),
      ),
      body: _loading
          ? CircularProgressIndicator()
          : SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
              mapType: MapType.normal,
              markers: _createMarker(),
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              // markers: _createMarker(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: false,
              buildingsEnabled: true,
              onTap: (LatLng latLang) {
                print('Clicked: $latLang');
              },
            ),
          ],
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //     return GoogleMap(
  //       mapType: MapType.normal,
  //       markers: _createMarker(),
  //       initialCameraPosition: CameraPosition(
  //         target: _initialPosition,
  //         zoom: 18.0,
  //       ),
  //       myLocationEnabled: true,
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller = controller;
  //       },
  //     );
  //   }
  // }
}

// AIzaSyDFidOHEK6EOLdV3NO3RritzioOpksVmlo