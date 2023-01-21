// record_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../Widget/transcribe_list_widget.dart';


class TranscribePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transcribes'),
        ),
        body: Column(
          children: [

            Expanded(
              child: TranscribeList(),
            ),

          ],

        ));
  }
}

