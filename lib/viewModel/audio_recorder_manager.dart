import 'dart:async';
import 'dart:io';
import 'package:code/model/record.model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioRecorderManager {
  bool isRecording = false;
  bool isPlaying = false;
  late File recordedFile;
  AudioPlayer audioPlayer = AudioPlayer();
  StreamController<String> _timerController = StreamController<String>();
  Stream<String> get timer => _timerController.stream;
  String _timer = "00:00:00";
  var _duration = new Duration(seconds: 0);
  Timer? _timerObj;
  RecordMp3 recordStatus = RecordMp3.instance;

  setRecordedFile(File file) {
    recordedFile = file;
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

  Future<String> startRecording() async {
    if (await checkPermission()) {
      String filePath = await _getFilePath();
      _timerController.sink.add("coucou");

      recordStatus.start(filePath, (type) async {
        recordedFile = File(filePath);
        isRecording = true;
      });
      return filePath;
    }
    return "";
  }

  Future<String> _getFilePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio${DateTime.now().millisecondsSinceEpoch}.mp3';
  }

  void stopRecording() {
    recordStatus.stop();
    isRecording = false;
  }

  void pauseRecording() {
    recordStatus.pause();
  }

  void resumeRecording() {
    recordStatus.resume();
  }

  void playRecording() async {
    if (recordedFile != null && !isPlaying) {
      int status = await audioPlayer.play(recordedFile.path, isLocal: true);
      // String timerValue = calculateTimer();
      // updateTimer(timerValue);
      _duration = new Duration(seconds: 0);
      _timerObj = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTimer());

      if (status == 1) {
        isPlaying = true;
      }
    }
  }



  void pausePlaying() {
    audioPlayer.pause();
    isPlaying = false;
  }

  void stopPlaying() {
    audioPlayer.stop();
    isPlaying = false;
  }

  void deleteRecording() {
    audioPlayer.stop();
    recordedFile.delete();
    isPlaying = false;
  }


  _updateTimer() {
    if (recordStatus.status == RecordStatus.RECORDING) {
        _duration = new Duration(seconds: _duration.inSeconds + 1);
        _timer = _duration.toString().split(".")[0];
        _timerController.sink.add(_timer);
    }
  }



}
