import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class MyPosition {
  final double longitude;
  final double latitude;

  const MyPosition({
    required this.longitude,
    required this.latitude
  });

  factory MyPosition.fromJson(Map<String, dynamic> json) {
    return MyPosition(
      longitude: json['longitude'],
      latitude: json['latitude']
    );
  }
}





class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  Set<Marker> _marker = {};
  // final Set<Marker> _list = {};


  @override
  void initState() {
    super.initState();
    //getData();
  }

 Future<void> fetchPosition(GoogleMapController controller) async {
    final response = await http
        .get(Uri.parse('https://us-central1-subtle-torus-393918.cloudfunctions.net/get-geoinfo'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var rb = response.body;
      // store json data into list
      var result_list = json.decode(rb) as List;
      var result_list_last = [result_list[result_list.length - 1]];
      Map<int ,MyPosition> result = result_list_last.asMap().map((i, element)=>MapEntry(i, MyPosition.fromJson(element)));
      Map<int, Marker> result2 = result.map((i, element)=> MapEntry(i, Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(element.longitude, element.latitude),
          infoWindow: InfoWindow(
            title: 'My Position',
          )
      )));
      List<Marker> final_result_list = [];
      result2.forEach((k, v) => final_result_list.add(v));
      Set<Marker> final_result = {...final_result_list};
      setState(() {
        _marker = final_result;
      });

      // return final_result;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load positions');
    }
  }

  getData() async {
    final mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = false;
      try {
        // Related issue: https://github.com/flutter/flutter/issues/105965
        await mapsImplementation.initializeWithRenderer(
          AndroidMapRenderer.latest,
        );
      } on PlatformException catch (exception) {
        if (exception.code == 'Renderer already initialized') {
          // Happens during hot reload
          return;
        }
        rethrow;
      }
    }
    // Set<Marker> temp =
    // await fetchPosition();
  }

  @override
  Widget build(BuildContext context) {
    String result = "";

    for (var element in _marker) {
      result += element.position.latitude.toString();
      result += " ";
      result += element.position.longitude.toString();
    }
    // return Text(result, style: const TextStyle(fontSize: 36));
    return Scaffold(
      body: GoogleMap(
        onMapCreated: fetchPosition,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
      markers: _marker,
      ),
    );
  }
}