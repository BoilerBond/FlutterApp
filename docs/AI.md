In order to access the REST API for the AI model, make an HTTP POST similar to the curl request below:

```bash
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=GEMINI_API_KEY" \
-H 'Content-Type: application/json' \
-X POST \
-d '{
  "contents": [{
    "parts":[{"text": "Explain how AI works"}]
    }]
   }'
```

In Dart/Flutter, it will likely look like this:
```dart
Future<Map<String, dynamic>> callGeminiApi(String prompt) async {
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=YOUR_GEMINI_API_KEY');
  
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
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to call Gemini API: ${response.statusCode}');
  }
}
```