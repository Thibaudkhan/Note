import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:code/Widget/record_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';


class AudioRecorderWidget extends StatefulWidget {
  @override
  _AudioRecorderWidgetState createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  String statusText = "";
  bool isComplete = false;
  late String recordFilePath;
  String _timer = "00:00:00";
  var _duration = new Duration(seconds: 0);
  Timer? _timerObj;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
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
                    startRecord();
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
                    pauseRecord();
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
                    stopRecord();
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
          Expanded(child: RecordList()),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              play();
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
    cleanTimer();
    stopRecord();
    super.dispose();
    print("dispose");
  }

  @override
  deactivate() {
    cleanTimer();
    stopRecord();
    super.deactivate();
    print("deactivate");
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }



  void startRecord() async {
    cleanTimer();

    bool hasPermission = await checkPermission();
    if(!hasPermission){
      statusText = "No microphone permission";
      return;
    }else if(RecordMp3.instance.status == RecordStatus.RECORDING){
      statusText = "Recording";
      return;
    }

    statusText = "Recording...";
    recordFilePath = await getFilePath();
    isComplete = false;
    RecordMp3.instance.start(recordFilePath, (type) {
      statusText = "Record error--->$type";
    });
    _duration = new Duration(seconds: 0);
    _timerObj = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTimer());

  }

  cleanTimer(){
    if(_timerObj != null){
      _timerObj!.cancel();
      _timerObj = null;
    }
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});

      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }


  void stopRecord() {

    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
    }
  }


  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  _updateTimer() {
    if (RecordMp3.instance.status == RecordStatus.RECORDING) {
      setState(() {
        _duration = new Duration(seconds: _duration.inSeconds + 1);
        _timer = _duration.toString().split(".")[0];
      });
    }
  }

}