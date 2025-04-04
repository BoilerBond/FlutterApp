import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  late final GenerativeModel _model;
  
  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    // The API key should be stored in .env file or fetched securely
    // For development, we're using a placeholder
    // In production, use environment variables or secure storage
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

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

      // Send request to Gemini API
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '0';
      
      // Parse the response to get the numerical value
      // First try direct parsing
      try {
        return int.parse(responseText);
      } catch (_) {
        // If that fails, try to extract a number from the text
        final RegExp regex = RegExp(r'(-?\d+)');
        final match = regex.firstMatch(responseText);
        if (match != null) {
          return int.parse(match.group(1) ?? '0');
        }
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
}
