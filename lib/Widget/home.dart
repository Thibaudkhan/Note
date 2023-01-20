import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //final List<Note> notes;
  List<Note> notes = [
    Note(audio: "audio1.mp3", plan: "Meeting with John", note: "Discussed project timelines and potential roadblocks. John is going to send over a proposal by the end of the week."),
    Note(audio: "audio2.mp3", plan: "Call with Jane", note: "Jane is interested in discussing potential collaborations. Set up a meeting next week to discuss further."),
    Note(audio: "audio3.mp3", plan: "Team meeting", note: "Discussed progress on current projects and assigned tasks for the next sprint."),
  ];

  //HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteCard(note: notes[index]);
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;

  NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('Note Plan: ${note.plan}'),
          Text('Note: ${note.note}'),
          //AudioPlayer(url: note.audio),
        ],
      ),
    );
  }
}

class Note {
  final String plan;
  final String note;
  final String audio;

  Note({required this.plan, required this.note, required this.audio});
}
