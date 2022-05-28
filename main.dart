import 'dart:async';

import 'package:cafe_map/shopdata.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cafe_map/database_helper.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

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

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;
  late StreamSubscription<Position> positionStream;
  final LocationSettings locationSettings = const LocationSettings(
    distanceFilter: 100,
  );
  late LatLng _initialPosition;
  late bool _loading = false;
  List<Shopdata>? shopdatas;
  late Shopdata shopdata;
  String googleApikey = "Myapikey";
  GoogleMapController? mapController; //controller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  String location = "Search Location";
  BitmapDescriptor? customIcon;



  @override
  void initState() {
    super.initState();

    refreshShopdatas();
    _getUserLocation(); // 現在地取得
    setCustomMarker(); // カスタムアイコン設定

    //位置情報が許可されていない時に許可をリクエストする
    Future(() async {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    });
  } // initState

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(12, 12)), 'assets/images/stb.png');
  }
  // icon by Icon8 https://icons8.com/

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  Future refreshShopdatas() async {
    setState(() => _loading = true);

    this.shopdatas = await DBHelper.instance.getAllShopdata();

    setState(() => _loading = false);
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
          ? const CircularProgressIndicator()
          : Stack(
            fit: StackFit.expand,
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: shopdatas!.map((Shopdata shop) {
                  List<String> latlng = shop.shoplatlng.split(',');
                  double latitude = double.parse(latlng[0]);
                  double longitude = double.parse(latlng[1]);
                  return Marker(
                    markerId: MarkerId(shop.id.toString()),
                    position: LatLng(latitude, longitude),
                    infoWindow: InfoWindow(title: shop.shopname, snippet: '${shop.wifiinfo}\n${shop.eigyojikan}'),
                    icon:  customIcon!,
                  );
                }).toSet(),
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
                onTap: (LatLng latLang) {
                  print('Clicked: $latLang');
                },
              ),

              Positioned(  //search input bar
                  top:-3,
                  child: InkWell(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleApikey,
                            mode: Mode.overlay,
                            types: [],
                            strictbounds: false,
                            language: 'ja',
                            components: [Component(Component.country, 'jp')],
                            //google_map_webservice package
                            onError: (err){
                              print(err);
                            }
                        );

                        if(place != null){
                          setState(() {
                            location = place.description.toString();
                          });

                          //form google_maps_webservice package
                          final _plist = GoogleMapsPlaces(apiKey:googleApikey,
                            apiHeaders: await GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );
                          String placeid = place.placeId!;
                          final detail = await _plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          final lat = geometry.location.lat;
                          final lang = geometry.location.lng;
                          var newlatlang = LatLng(lat, lang);
                          await (await _controller.future).moveCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 14.4776))
                          );
                        }
                      },
                      child:Padding(
                        padding: EdgeInsets.all(15),
                        child: Card(
                          child: Container(
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              child: ListTile(
                                title:Text(location, style: TextStyle(fontSize: 18),),
                                trailing: Icon(Icons.search),
                                dense: true,
                              )
                          ),
                        ),
                      )
                  )
              )
            ],
          ),
    );
  }
}

