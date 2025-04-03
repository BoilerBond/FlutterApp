import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Content moderation utility class for checking both images and text
/// Uses Google Cloud Vision API for image moderation and 
/// Google Cloud Natural Language API for text moderation
class ContentModeration {
  /// Your Google Cloud API key - store this securely, preferably in environment variables
  /// For this example, we're using a placeholder
  static const String _apiKey = 'YOUR_GOOGLE_API_KEY';
  
  /// Vision API endpoint for image content moderation
  static const String _visionApiUrl = 'https://vision.googleapis.com/v1/images:annotate';
  
  /// Natural Language API endpoint for text content moderation
  static const String _languageApiUrl = 'https://language.googleapis.com/v1/documents:analyzeSentiment';

  /// Threshold for inappropriate content (scale from 0 to 1)
  static const double _inappropriateThreshold = 0.7;
  static const double _negativeThreshold = -0.5;
  
  /// Result type for content moderation
  enum ContentStatus {
    appropriate,    // Content is safe
    inappropriate,  // Content is not safe
    uncertain,      // Can't determine definitively
    error           // Error during processing
  }

  /// Result class with detailed information
  class ModerationResult {
    final ContentStatus status;
    final String message;
    final double? score;
    final Map<String, dynamic>? details;
    
    ModerationResult({
      required this.status,
      required this.message,
      this.score,
      this.details,
    });
  }
  
  /// Checks if an image is appropriate/SFW
  /// Takes either a File object or Uint8List (for memory images)
  static Future<ModerationResult> checkImage({File? imageFile, Uint8List? imageBytes}) async {
    try {
      if (imageFile == null && imageBytes == null) {
        return ModerationResult(
          status: ContentStatus.error,
          message: 'No image provided',
        );
      }
      
      // Get image bytes
      final bytes = imageFile != null ? await imageFile.readAsBytes() : imageBytes!;
      final base64Image = base64Encode(bytes);
      
      // Prepare request to the Vision API
      final Map<String, dynamic> requestBody = {
        'requests': [
          {
            'image': {
              'content': base64Image,
            },
            'features': [
              {
                'type': 'SAFE_SEARCH_DETECTION',
                'maxResults': 1,
              },
            ],
          },
        ],
      };
      
      // Send request
      final response = await http.post(
        Uri.parse('$_visionApiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode != 200) {
        return ModerationResult(
          status: ContentStatus.error,
          message: 'API error: ${response.statusCode}',
          details: jsonDecode(response.body),
        );
      }
      
      // Parse response
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final safeSearchAnnotation = responseData['responses'][0]['safeSearchAnnotation'];
      
      // Convert likelihoods to scores (VERY_UNLIKELY=0, VERY_LIKELY=4)
      final Map<String, int> likelihoodMap = {
        'UNKNOWN': 0,
        'VERY_UNLIKELY': 0,
        'UNLIKELY': 1,
        'POSSIBLE': 2,
        'LIKELY': 3,
        'VERY_LIKELY': 4,
      };
      
      // Check for adult, violence, racy content
      final int adultScore = likelihoodMap[safeSearchAnnotation['adult']] ?? 0;
      final int violenceScore = likelihoodMap[safeSearchAnnotation['violence']] ?? 0;
      final int racyScore = likelihoodMap[safeSearchAnnotation['racy']] ?? 0;
      
      // Calculate overall score (0-1 scale)
      final double maxPossibleScore = 4.0; // VERY_LIKELY is 4
      final double overallScore = 
        [adultScore, violenceScore, racyScore].reduce((a, b) => a > b ? a : b) / maxPossibleScore;
      
      // Determine if image is appropriate
      if (overallScore >= _inappropriateThreshold) {
        return ModerationResult(
          status: ContentStatus.inappropriate,
          message: 'Image contains inappropriate content',
          score: overallScore,
          details: safeSearchAnnotation,
        );
      } else if (overallScore >= _inappropriateThreshold / 2) {
        return ModerationResult(
          status: ContentStatus.uncertain,
          message: 'Image may contain inappropriate content',
          score: overallScore,
          details: safeSearchAnnotation,
        );
      } else {
        return ModerationResult(
          status: ContentStatus.appropriate,
          message: 'Image is appropriate',
          score: overallScore,
          details: safeSearchAnnotation,
        );
      }
    } catch (e) {
      return ModerationResult(
        status: ContentStatus.error,
        message: 'Error analyzing image: $e',
      );
    }
  }
  
  /// Checks if text is appropriate/SFW
  static Future<ModerationResult> checkText(String text) async {
    try {
      if (text.isEmpty) {
        return ModerationResult(
          status: ContentStatus.error,
          message: 'No text provided',
        );
      }
      
      // Prepare request to the Natural Language API
      final Map<String, dynamic> requestBody = {
        'document': {
          'type': 'PLAIN_TEXT',
          'content': text,
        },
        'encodingType': 'UTF8',
      };
      
      // Send request
      final response = await http.post(
        Uri.parse('$_languageApiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode != 200) {
        return ModerationResult(
          status: ContentStatus.error,
          message: 'API error: ${response.statusCode}',
          details: jsonDecode(response.body),
        );
      }
      
      // Parse response
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final double sentimentScore = responseData['documentSentiment']['score'].toDouble();
      
      // Simple check based on negative sentiment
      // For more extensive content moderation, we would use additional APIs or custom models
      if (sentimentScore <= _negativeThreshold) {
        return ModerationResult(
          status: ContentStatus.inappropriate,
          message: 'Text may contain negative content',
          score: sentimentScore,
          details: responseData,
        );
      } else {
        return ModerationResult(
          status: ContentStatus.appropriate,
          message: 'Text is appropriate',
          score: sentimentScore,
          details: responseData,
        );
      }
    } catch (e) {
      return ModerationResult(
        status: ContentStatus.error,
        message: 'Error analyzing text: $e',
      );
    }
  }
  
  /// Optional: Simple profanity filter that can be used client-side before API calls
  /// This is a basic implementation and not a replacement for API-based moderation
  static bool containsProfanity(String text) {
    final List<String> profanityList = [
      'badword1',
      'badword2',
      // Add common profanity words here
    ];
    
    final lowercaseText = text.toLowerCase();
    return profanityList.any((word) => lowercaseText.contains(word));
  }
}
