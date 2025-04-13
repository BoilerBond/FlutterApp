import 'dart:math';

Future<Map<String, String>?> generateFlexibleDateIdea({
  required String time,
  required String locationType,
  required String activityType,
}) async {
  // Activies and locations
  final activities = [
    {
      "activity": "Go stargazing",
      "type": "Romantic",
      "times": ["Evening", "Night"],
      "tags": ["chill", "romantic"]
    },
    {
      "activity": "Grab a coffee and chat",
      "type": "Food",
      "times": ["Morning", "Afternoon"],
      "tags": ["cozy", "talk"]
    },
    {
      "activity": "Paint pottery together",
      "type": "Creative",
      "times": ["Afternoon", "Evening"],
      "tags": ["hands-on", "indoor"]
    },
    {
      "activity": "Explore a farmer's market",
      "type": "Explore",
      "times": ["Morning"],
      "tags": ["local", "fresh"]
    },
    {
      "activity": "Share ice cream and talk",
      "type": "Food",
      "times": ["Afternoon", "Evening"],
      "tags": ["fun", "sweet"]
    },
    {
      "activity": "Do a photo walk",
      "type": "Creative",
      "times": ["Afternoon"],
      "tags": ["campus", "outdoor"]
    },
    {
      "activity": "Play board games",
      "type": "Playful",
      "times": ["Evening", "Night"],
      "tags": ["fun", "cozy"]
    },
  ];

  final locations = [
    {
      "location": "Slayter Hill",
      "type": "Outdoor",
      "times": ["Evening", "Night"],
      "tags": ["open", "romantic"]
    },
    {
      "location": "Greyhouse Coffee",
      "type": "Indoor",
      "times": ["Morning", "Afternoon"],
      "tags": ["cozy", "cafe"]
    },
    {
      "location": "All Fired Up",
      "type": "Indoor",
      "times": ["Afternoon", "Evening"],
      "tags": ["art", "creative"]
    },
    {
      "location": "Farmer’s Market",
      "type": "Outdoor",
      "times": ["Morning"],
      "tags": ["market", "fresh"]
    },
    {
      "location": "Silver Dipper",
      "type": "Outdoor",
      "times": ["Afternoon", "Evening"],
      "tags": ["ice cream", "sweet"]
    },
    {
      "location": "Engineering Fountain",
      "type": "Outdoor",
      "times": ["Afternoon"],
      "tags": ["iconic", "campus"]
    },
    {
      "location": "Dorm lounge",
      "type": "Indoor",
      "times": ["Evening", "Night"],
      "tags": ["relaxed", "games"]
    },
  ];

  // Filtering
  final validActivities = activities.where((a) =>
      a["type"] == activityType &&
      (a["times"] as List).contains(time)).toList();

  final validLocations = locations.where((l) =>
      l["type"] == locationType &&
      (l["times"] as List).contains(time)).toList();

  if (validActivities.isEmpty || validLocations.isEmpty) return null;

  // Random picking of an activity and location based on fitting criteria
  final random = Random();
  final activity = validActivities[random.nextInt(validActivities.length)];
  final location = validLocations[random.nextInt(validLocations.length)];

 // Return suggestion
 return {
  "description": "${activity['activity']} at ${location['location']}",
  "activity": activity['activity'] as String,
  "location": location['location'] as String,
  "activityType": activityType,
  "locationType": locationType,
  "time": time,
};

}
