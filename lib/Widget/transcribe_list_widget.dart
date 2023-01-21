import 'package:code/model/transcribe.model.dart';
import 'package:flutter/material.dart';

import '../view/transcribe_content_page.dart';

class TranscribeList extends StatefulWidget {
  @override
  _TranscribeListState createState() => _TranscribeListState();
}

class _TranscribeListState extends State<TranscribeList> {
  Future<List<Map<String, dynamic>>>? listOfTranscribes;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTranscribes();
  }

  void _loadTranscribes() async {
    // Get the transcribes from your database or file system
    //_transcribes = await getTranscribes();
    listOfTranscribes = getTranscriptionFiles();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading && listOfTranscribes != null
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<List<Map<String, dynamic>>>(
            initialData: [],
            future: listOfTranscribes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final transcribe = snapshot.data![index];

                    return Container(
                      height: 100,
                      margin: EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TranscribeContentView(title : transcribe["title"],content: transcribe["content"]),
                            ),
                          );
                          // Do something when the card is tapped
                        },
                        child: Card(
                            child: Center(
                              child: Text('Title : ${transcribe["title"]}',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),),
                      ),
                    );
                  },
                );
              } else {
                return Text("${snapshot.error}");
              }
            });
  }
}
