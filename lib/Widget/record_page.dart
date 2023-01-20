import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecordList extends StatefulWidget {
  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  List<File> _records = [];
  var files = <File>[];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() async {
    // Get the directory where the records are stored
    var dir = await getApplicationDocumentsDirectory();
    var recordsDir = Directory("${dir.path}/record");

    // If the directory doesn't exist, create it
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
          return Card(
            child:Row(
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
                        //play the record
                          break;
                        case 'pause':
                        //pause the record
                          break;
                        case 'stop':
                        //stop the record
                          break;
                        case 'delete':
                        //delete the record
                          break;
                        case 'Transcribe':
                        //delete the record
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

          );
        });
  }
}


/*ListTile(
            title: Text(_records[index].path.split("/").last),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () async {
                int result = await _audioPlayer.play(_records[index].path);
                if (result == 1) {
                  print("Playing");
                }
              },
            ),*/