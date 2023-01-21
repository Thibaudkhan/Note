import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';

import '../viewModel/audio_recorder_manager.dart';
import 'record_list_widget.dart';


class AudioRecorderWidget extends StatefulWidget {
  @override
  _AudioRecorderWidgetState createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  String statusText = "";
  bool isComplete = false;
  bool isPlaying = false;
  late String recordFilePath;
  String _timer = "00:00:00";
  AudioRecorderManager _audioRecorderManager = AudioRecorderManager();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.red.shade300),
                    child: const Center(
                      child: Text(
                        'start',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () async {
                    _audioRecorderManager.startRecording();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.blue.shade300),
                    child: Center(
                      child: Text(
                        RecordMp3.instance.status == RecordStatus.PAUSE
                            ? 'resume'
                            : 'pause',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    _audioRecorderManager.pauseRecording();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.green.shade300),
                    child: const Center(
                      child: Text(
                        'stop',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    _audioRecorderManager.stopRecording();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              statusText,
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
          Text("Timer: $_timer"),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if(!isPlaying){
                _audioRecorderManager.playRecording();
                isPlaying = true;

              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: AlignmentDirectional.center,
              width: 100,
              height: 50,
              child: isComplete && recordFilePath != null
                  ? const Text(
                "play",
                style: TextStyle(color: Colors.red, fontSize: 20),
              )
                  : Container(),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  dispose() {
    //_audioRecorderManager.audioPlayer.dispose();
    _audioRecorderManager.stopRecording();
    //RecordMp3.instance.dispose();
    super.dispose();

    print("dispose");
  }

  @override
  deactivate() {
    //_audioRecorderManager.audioPlayer.dispose();
    _audioRecorderManager.stopRecording();
    super.deactivate();
    print("deactivate");
  }


}