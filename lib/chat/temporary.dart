// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:chatbot/keys_before_api_integration.dart';

// ///fyi: below hardcoded function is used temporarily to get new message from bot
// /// until we do api integration with out backend

// Future<String> talkToGPT(String userMsg) async {
//   final url = Uri.parse('https://api.openai.com/v1/chat/completions');
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $alternateKey1',
//   };
//   final requestBody = jsonEncode({
//     'model': 'gpt-3.5-turbo',
//     'messages': [
//       {
//         'role': 'user',
//         'content':
//             "$contextToAI user's messsge you need to responde to: $userMsg"
//       }
//     ],
//     'temperature': 0.7,
//   });
//   String msgOfBot;
//   try {
//     final response = await http.post(url, headers: headers, body: requestBody);
//     Map<String, dynamic> gptResp = jsonDecode(response.body);
//     msgOfBot = gptResp["choices"][0]["message"]["content"];
//   } catch (e) {
//     msgOfBot = e.toString();
//   }
//   return msgOfBot;
// }
