import 'package:flutter/material.dart';

class TranscribeContentView extends StatelessWidget {
  final String title;
  final String content;

  TranscribeContentView({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                content,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
