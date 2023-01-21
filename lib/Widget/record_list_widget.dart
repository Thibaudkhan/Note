import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';

import '../model/transcribe.model.dart';
import '../viewModel/audio_recorder_manager.dart';

class RecordList extends StatefulWidget {
  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  List<File> _records = [];
  var files = <File>[];
  final _timerController = StreamController<String>();


  @override
  void initState() {
    super.initState();

    _loadRecords();
  }


  void _loadRecords() async {
    // Get the directory where the records are stored
    var dir = await getApplicationDocumentsDirectory();
    var recordsDir = Directory("${dir.path}/record");

    if (!recordsDir.existsSync()) {
      recordsDir.createSync();
    }

    // Get a list of all the files in the directory
    var fileSystemEntities = Directory("${dir.path}/record").listSync();
    files = fileSystemEntities.where((entity) => entity is File).cast<File>().toList();
    print("files : $files");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: files.length,
        itemBuilder: (BuildContext context, int index) {

          AudioRecorderManager audioRecorderWidget = AudioRecorderManager();

          audioRecorderWidget.setRecordedFile(files[index]);
          return Card(
            child:Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,

                        child: Text('Note Plan: ${files[index].path}')),
                    //AudioPlayer(url: note.audio),
                    Expanded(
                      flex: 1,
                      child: PopupMenuButton<String>(
                        onSelected: (String result) {
                          switch (result) {
                            case 'play':
                              print("files : ${audioRecorderWidget.recordedFile}");
                              audioRecorderWidget.playRecording();
                            //play the record
                              break;
                            case 'pause':
                              audioRecorderWidget.pausePlaying();

                              //pause the record
                              break;
                            case 'stop':
                              audioRecorderWidget.stopPlaying();

                              //stop the record
                              break;
                            case 'delete':
                            //delete the record
                              break;
                            case 'transcribe':
                              print("Transcribe");
                              transcribeAudio(files[index].path);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'play',
                            child: Text('Play'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'pause',
                            child: Text('Pause'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'stop',
                            child: Text('Stop'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'transcribe',
                            child: Text('Transcribe'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text("_timer")

              ],
            ),

          );
        });

  }


}

