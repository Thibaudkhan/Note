import 'dart:async';
import 'package:flutter/services.dart';
import 'package:record/record.dart';

class AudioRecorder {
  // Method channel for interacting with the native recording functionality
  static const MethodChannel _channel =
  MethodChannel('com.example.app/audio_recorder');

  // The current status of the recorder
  String _status = "stopped";

  // Stream controller for the recording data
  StreamController<List<int>> _recordingController = StreamController<List<int>>();

  // Start recording
  Future<void> startRecording() async {
    try {
      _status = 'recording';
      await _channel.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      _status = 'stopped';
      print(e);
    }
  }

  // Stop recording
  Future<void> stopRecording() async {
    try {
      _status = 'stopped';
      await _channel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      _status = 'stopped';
      print(e);
    }
  }

  // Pause recording
  Future<void> pauseRecording() async {
    try {
      _status = 'paused';
      await _channel.invokeMethod('pauseRecording');
    } on PlatformException catch (e) {
      _status = 'stopped';
      print(e);
    }
  }

  // Get the current status of the recorder
  String get status => _status;

  // Get the stream of recording data
  Stream<List<int>> get recordingData => _recordingController.stream;

}