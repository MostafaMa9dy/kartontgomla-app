import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:chat_gpt/models/models.dart';


class OpenAIServices {
  final String openAIKey;
  final ChatGPTConfig? chatGPTConfig;
  OpenAIServices({required this.openAIKey,required this.chatGPTConfig,});

  Future<String> generateResponse(String prompt) async {
    try{
      var url = Uri.https("api.openai.com", "/v1/chat/completions");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $openAIKey"
        },
        body: json.encode({
          "model": chatGPTConfig?.model ?? "text-davinci-003",
          "messages":[
            {
              "role": "user",
              "content": prompt,
            }
          ],
          'temperature': chatGPTConfig?.temperature ?? 0,
          'max_tokens': chatGPTConfig?.maxToken ?? 2000,
          'top_p': chatGPTConfig?.topP ?? 1,
          'frequency_penalty':chatGPTConfig?.frequencyPenalty ?? 0.0,
          'presence_penalty':chatGPTConfig?.presencePenalty ?? 0.0,
          'n': chatGPTConfig?.n ?? 1,
          'stream': chatGPTConfig?.stream ?? false,
          'logprobs': chatGPTConfig?.logprobs,
          'stop': chatGPTConfig?.stop,
        }),
      );

      // Do something with the response
      Map<String, dynamic> newResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if(newResponse['choices']?[0]?['message']?['content'] == null){
        throw Exception("Too many requests in 1 hour, please try it later.");
      }
      return newResponse['choices'][0]['message']['content'];
    }catch(e){
      rethrow;
    }
  }
}
