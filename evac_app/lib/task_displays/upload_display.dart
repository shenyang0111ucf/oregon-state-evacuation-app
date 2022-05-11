import 'package:evac_app/export/results_exporter.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadDisplay extends StatefulWidget {
  const UploadDisplay({
    Key? key,
    required this.topContext,
    required this.drillResults,
    required this.exitDrill,
  }) : super(key: key);

  final BuildContext topContext;
  final DrillResults drillResults;
  final Function exitDrill;

  @override
  State<UploadDisplay> createState() => _UploadDisplayState();
}

class _UploadDisplayState extends State<UploadDisplay> {
  late Widget dialogContent;

  @override
  void initState() {
    dialogContent = UploadDialogContent(onOk: onOk);
    super.initState();
  }

  // function to actually upload results
  Future<void> _uploadResults() async {
    // make results exporter
    final resultsExporter = ResultsExporter(drillResults: widget.drillResults);
    // export
    await resultsExporter.export();
  }

  void onOk() async {
    // change display to LoadingDialogContent
    setState(() {
      dialogContent = LoadingDialogContent();
    });

    // this is completely screwed up right now, not parsing string like before...
    // upload the results
    await _uploadResults();

    await Future.delayed(Duration(seconds: 2));

    // notify user the upload is complete
    setState(() {
      dialogContent = UploadCompleteDialogContent();
    });

    await Future.delayed(Duration(seconds: 2));
    // need to also complete drill
    widget.exitDrill();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: dialogContent);
  }
}

class UploadDialogContent extends StatelessWidget {
  const UploadDialogContent({Key? key, required this.onOk}) : super(key: key);

  final Function onOk;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Icon(
            CupertinoIcons.share,
            size: 128,
            color: Colors.black,
          ),
          SizedBox(height: 20),
          Text(
            'Ready to complete the Evacuation Drill and upload your results?',
            style: GoogleFonts.getFont(
              'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 36,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          CupertinoButton.filled(
            child: Text('Yes!'),
            onPressed: () {
              onOk();
            },
          ),
        ],
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class LoadingDialogContent extends StatelessWidget {
  const LoadingDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: SizedBox(
            child: CupertinoActivityIndicator(
              radius: 64,
            ),
            height: 128,
            width: 128,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'loading…',
          style: GoogleFonts.getFont(
            'Open Sans',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class UploadCompleteDialogContent extends StatelessWidget {
  const UploadCompleteDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.check_mark_circled,
          size: 128,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'Thanks!',
          style: GoogleFonts.getFont(
            'Open Sans',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'Your results have been uploaded. Thank you for your participation! 👋',
          style: GoogleFonts.getFont(
            'Open Sans',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        CupertinoButton.filled(
          child: Text('Complete Drill'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
