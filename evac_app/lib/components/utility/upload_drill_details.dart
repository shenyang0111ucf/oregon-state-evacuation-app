import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evac_app/models/drill_details/drill_details.dart';
import 'package:flutter/material.dart';

class UploadDrillDetails extends StatefulWidget {
  UploadDrillDetails({Key? key}) : super(key: key);

  @override
  State<UploadDrillDetails> createState() => _UploadDrillDetailsState();
}

class _UploadDrillDetailsState extends State<UploadDrillDetails> {
  @override
  Widget build(BuildContext context) {
    // Size pageSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: OutlinedButton(
          child: Text('Upload Example DrillDetails'),
          onPressed: () {
            _uploadExampleDrillDetails(context);
          },
        ),
      ),
    );
  }

  void _uploadExampleDrillDetails(BuildContext context) async {
    bool valid = await FirebaseFirestore.instance
        .collection('DrillDetails')
        .add(DrillDetails.testTelemetry().toJson())
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
    ;
    if (valid) {
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('dangit 🤡')));
    }
  }
}
