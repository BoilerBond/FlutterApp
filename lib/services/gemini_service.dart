import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  final String _apiKey = 'AIzaSyDuDyVRY6odZ5W4-3r8pPFQdzvxYVnoDNA'; // TODO: Replace with your API key before production
  
  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal();

  /// Converts a long form text answer to a numerical scale from -5 to 5
  /// [question] The long form question that was asked
  /// [answer] The user's text response to the question
  /// Returns a Future with the numerical value between -5 and 5
  Future<int> convertLongFormToScale(String question, String answer) async {
    if (answer.isEmpty) {
      return 0; // Default value for empty answers
    }

    try {
      // Prepare the prompt for Gemini
      final prompt = """I need to convert a user's response to a long form question into a numerical scale from -5 to 5.

Question: "$question"
User's answer: "$answer"

Based on the user's answer, provide a single integer value from -5 to 5, where:
- -5 represents extremely negative or closed-minded responses
- 0 represents neutral or balanced responses
- 5 represents extremely positive, open-minded, or growth-oriented responses

Return only the numerical value (just the number) without any explanation.""";

      // Call the Gemini API directly using HTTP
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final responseText = jsonResponse['candidates'][0]['content']['parts'][0]['text'] ?? '0';
        
        // Parse the response to get the numerical value
        // First try direct parsing
        try {
          return int.parse(responseText.trim());
        } catch (_) {
          // If that fails, try to extract a number from the text
          final RegExp regex = RegExp(r'(-?\d+)');
          final match = regex.firstMatch(responseText);
          if (match != null) {
            return int.parse(match.group(1) ?? '0');
          }
        }
      } else {
        print('Failed to call Gemini API: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      // Default return if parsing fails
      return 0;
    } catch (e) {
      print('Error in Gemini API call: $e');
      return 0; // Default value in case of error
    }
  }
  
  /// Batch converts multiple long form answers into a map of scales
  /// Returns a map where keys are the questions and values are the -5 to 5 scale values
  Future<Map<String, int>> batchConvertLongFormToScales(
      Map<String, String> questionsAndAnswers) async {
    Map<String, int> results = {};
    
    for (var entry in questionsAndAnswers.entries) {
      results[entry.key] = await convertLongFormToScale(entry.key, entry.value);
    }
    
    return results;
  }

  Future<String> generateDailyPrompt() async {
    final prompt = """You are a conversation starter assistant for a dating app.
Generate a single meaningful, thought-provoking question that can help two people get to know each other better.

Only return the question. Do not include any additional text or commentary.
Examples:
- What's a memory that shaped who you are today?
- If you could relive one day in your life, which would it be and why?
- What does a fulfilling life look like to you?

Only return the question on one line.""";

    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final responseText = jsonResponse['candidates'][0]['content']['parts'][0]['text'] ?? '';
        return responseText.trim();
      } else {
        print('Failed to generate daily prompt: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error generating daily prompt: $e');
    }

    return "What's something interesting you've learned recently?";
  }
}