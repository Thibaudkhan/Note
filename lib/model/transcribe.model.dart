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

Future<http.Response> uploadFile() async{
  Directory directory = await getApplicationDocumentsDirectory();
  var dbPath = join(directory.path, "test.wav");
  final file = File(dbPath);
  final bytes = await file.readAsBytes();
  final uploadResponse = await http.post(uri, headers: headers, body: bytes);

  final audioUrl = jsonDecode(uploadResponse.body)["upload_url"];

  final transcriptRequest = {
    'audio_url': audioUrl,
    'language_code': 'fr',
  };
  return await http.post(transcripte_uri, headers: headers, body: jsonEncode(transcriptRequest));

}



Future<void> transcribeAudio() async {
  // Upload the audio file to AssemblyAI

  final transcriptResponse = await uploadFile();
  final id = jsonDecode(transcriptResponse.body)["id"];
  var resultText;
  // Wait for transcription to complete, and then save the resulting transcript
  while (true) {
    transcripte_uri = Uri.parse("$TRANSCRIPTION_ENDPOINT/$id");
    // Get updated transcription info
    final pollingResponse = await http.get(transcripte_uri, headers: headers);

    // If the transcription is complete, save it to a .txt file
    if (jsonDecode(pollingResponse.body)['status'] == 'completed') {
      resultText = jsonDecode(pollingResponse.body)['text'];
      //final file = File("$id.txt");
      //await file.writeAsString(jsonDecode(pollingResponse.body)['text']);
      print('Transcript saved to $id.txt');
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
