import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Endpoints for uploading and transcribing audio

const UPLOAD_ENDPOINT = "https://api.assemblyai.com/v2/upload";
var uri = Uri.parse(UPLOAD_ENDPOINT);

const TRANSCRIPTION_ENDPOINT = "https://api.assemblyai.com/v2/transcript";
var transcripte_uri = Uri.parse(TRANSCRIPTION_ENDPOINT);

final apiKey = "68123430d16b4cf49748f82e94444b6e";
final headers = {
  "authorization": apiKey,
  "content-type": "application/json"
};

Future<http.Response> uploadFile(String path) async{
  Directory directory = await getApplicationDocumentsDirectory();
  var dbPath = join(directory.path, "test.wav");
  final file = File(path);
  final bytes = await file.readAsBytes();
  final uploadResponse = await http.post(uri, headers: headers, body: bytes);

  final audioUrl = jsonDecode(uploadResponse.body)["upload_url"];

  final transcriptRequest = {
    'audio_url': audioUrl,
    'language_code': 'fr',
  };
  print("before http");
  return await http.post(transcripte_uri, headers: headers, body: jsonEncode(transcriptRequest));

}

// void getTranscriptionFiles() async {
//   // Get the directory where the transcriptions are stored
//   Directory directory = await getApplicationDocumentsDirectory();
//   String path = "${directory.path}/transcription";
//   var dir = Directory(path);
//   print("dir : $dir");
//   if (!dir.existsSync()) {
//     print("The directory does not exist.");
//     return;
//   }
//
//   // Get a list of all the files in the directory
//   var files = dir.listSync();
//   for (var file in files) {
//     if (file is File) {
//       print(file.path);
//     }
//   }
// }


Future<List<Map<String, dynamic>>> getTranscriptionFiles() async {
  var dir = await getApplicationDocumentsDirectory();
  var transcriptionDir = Directory("${dir.path}/transcription");
  List<Map<String, dynamic>> transcribtionFiles = [];

  if (transcriptionDir.existsSync()) {
    var fileSystemEntities = transcriptionDir.listSync();
    var files = fileSystemEntities.where((entity) => entity is File).cast<File>().toList();
    for (var file in files) {
      var fileContent = await file.readAsString();
      var fileName = file.path.split("/").last.split(".").first;
      transcribtionFiles.add({
        "title": fileName,
        "content": fileContent
      });
    }
  }
  return transcribtionFiles;
}



 Future<void> transcribeAudio(String path) async {
  // Upload the audio file to AssemblyAI
  late final Directory directory;
  final transcriptResponse = await uploadFile(path);
  print(" body : ${transcriptResponse.body}");
  final id = jsonDecode(transcriptResponse.body)["id"];
  var resultText;
  // Wait for transcription to complete, and then save the resulting transcript
  while (true) {
    transcripte_uri = Uri.parse("$TRANSCRIPTION_ENDPOINT/$id");
    // Get updated transcription info
    final pollingResponse = await http.get(transcripte_uri, headers: headers);

    // If the transcription is complete, save it to a .txt file
    if (jsonDecode(pollingResponse.body)['status'] == 'completed') {
      directory = await getApplicationDocumentsDirectory();

      resultText = jsonDecode(pollingResponse.body)['text'];
      String fileName = path.split("/").last;
      fileName.substring(0, fileName.lastIndexOf("."));
      String sdPath = "${directory.path}/transcription";
      var d = Directory(sdPath);
      if (!d.existsSync()) {
        d.createSync(recursive: true);
      }
      final file = File("${directory.path}/transcription/$fileName.txt");
      await file.writeAsString(jsonDecode(pollingResponse.body)['text']);
      print('Transcript saved to $path.txt');
      break;
    }
    // If the transcription has failed, raise an Exception
    else if (jsonDecode(pollingResponse.body)['status'] == 'error') {
      throw Exception("Transcription failed. Make sure a valid API key has been used.");
    }
    // Otherwise, print that the transcription is in progress
    else {
      print("Transcription queued or processing ...");
      await Future.delayed(Duration(seconds: 5));
    }
  }
}
