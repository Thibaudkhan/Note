// record_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../Widget/record_list_widget.dart';
import '../Widget/recorder_widget.dart';

class RecordPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      body: Column(
      children: [
        Expanded(
          child: AudioRecorderWidget(),
        ),
        Expanded(
          child: RecordList(),
        ),

      ],

    ));
  }
}

