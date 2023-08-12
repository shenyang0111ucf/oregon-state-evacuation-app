import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:evac_app/components/google_maps_marker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyReportForm extends StatefulWidget {
  const MyReportForm({super.key});

  @override
  MyReportFormState createState() {
    return MyReportFormState();
  }
}

class MyReportFormState extends State<MyReportForm> {
  final _formKey = GlobalKey<FormState>();
  var disasters = <String>[
    'Hurricane',
    'Earthquake',
    'Avalanche',
    'Other',
  ];
  XFile? image;
  ImagePicker picker = ImagePicker();

  String dropdownValue = 'Hurricane';
  String inputValue = '';
  String comments = '';
  Position? _currentPosition;

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  void submitValues() async {
    File file = File(image!.path);
    Blob blob = new Blob(await file.readAsBytes());
    String img64 = base64Encode(blob.bytes);
    String diaster_name = dropdownValue;
    if (dropdownValue == 'Other') {
      diaster_name = inputValue;
    }
    List<double?> position_list = [_currentPosition?.latitude, _currentPosition?.longitude];
    // Map<String, dynamic> info = {
    //   "disaster_name": diaster_name,
    //   "position": position_list,
    //   "comment": comments,
    //   "photo": blob
    // };

    final response = await http
        .post(
        Uri.parse('https://us-central1-subtle-torus-393918.cloudfunctions.net/post-geoinfo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "disaster_name": diaster_name,
          "position": position_list,
          "comment": comments,
          "photo": img64
        })
        );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("Successful!");
      return;
    } else {
      print(response.statusCode);
      print(jsonEncode(<String, dynamic>{
        "disaster_name": diaster_name,
        "position": position_list,
        "comment": comments,
        "photo": img64.substring(0, 100)
      }));
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to add info!');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key:_formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
            children: <Widget>[
              const Text('Diaster Type',
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold)),
              DropdownButtonFormField(
                dropdownColor: Colors.greenAccent,
                value: dropdownValue,
                items: disasters.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 20),
                      )
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
              TextFormField(
                validator: (value) {
                  if (dropdownValue == 'Other' && (value == null || value.isEmpty)) {
                    return 'please enter some text';
                  }
                  return null;
                },
                onSaved: (String? newValue) {
                  setState(() {
                    inputValue = newValue!;
                  });
                },
              ),
              const Text('GPS',
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _getCurrentPosition,
                        child: const Text('Get my position'),
                      ),
                      Text('LAT: ${_currentPosition?.latitude ?? ""}'),
                      Text('LNG: ${_currentPosition?.longitude ?? ""}')
                    ]
                  )
              ),
              const Text('Comments',
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Comments',
                  border: OutlineInputBorder(),
                ),
                style:TextStyle(fontSize: 20),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'please enter some comments';
                  // }
                  return null;
                },
                onSaved: (String? newValue) {
                  setState(() {
                    comments = newValue!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  myAlert();
                },
                child: Text('Upload Photo'),
              ),
              image != null
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    //to show image, you type like this.
                    File(image!.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                  ),
                ),
              )
                  : Text(
                "No Image",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //add save to database logic here.
                        _formKey.currentState!.save();
                        submitValues();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  )
              )
            ]
        )
      )
    );
  }
}

class DataGathering extends StatelessWidget {
  const DataGathering({
    Key? key,
    required this.title,
    // required this.child,
    this.endDrawer,
    this.fAB,
    this.backButton,
    this.backButtonFunc,
  }) : super(key: key);

  final String title;
  // final Widget child;
  final Widget? endDrawer;
  final FloatingActionButton? fAB;
  final bool? backButton;
  final Function? backButtonFunc;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                title,
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Index'),
                  Tab(text: 'Drill'),
                  Tab(text: 'Report'),
                  Tab(text: 'Mine')
                ],
              )
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MapScreen(),
              Text('Leave blank intentionally', style: const TextStyle(fontSize: 36)),
              MyReportForm(),
              Text('Read database based on user ID', style: const TextStyle(fontSize: 36)),
            ],
          ),
          endDrawer: endDrawer,
          floatingActionButton: (fAB != null)
              ? Builder(
            builder: (context) {
              return fAB!;
            },
          )
              : null,
        )
      )
    );
  }
}
