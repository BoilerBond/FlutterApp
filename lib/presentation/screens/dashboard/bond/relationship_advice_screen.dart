import 'package:flutter/material.dart';
import '../../../../data/entity/app_user.dart';

class RelationshipAdviceScreen extends StatelessWidget {
  final AppUser user;
  final AppUser match;

  const RelationshipAdviceScreen({super.key, required this.user, required this.match});

  @override
  Widget build(BuildContext context) {
    final datingAdvice = _getAdvice(isLongTerm: false);
    final longTermAdvice = _getAdvice(isLongTerm: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Relationship Advice"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dating Advice", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...datingAdvice.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $tip"),
            )),

            const SizedBox(height: 24),
            const Text("Long-Term Relationship Advice", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...longTermAdvice.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $tip"),
            )),
          ],
        ),
      ),
    );
  }

  List<String> _getAdvice({required bool isLongTerm}) {
    final traits = user.personalTraits;
    final matchTraits = match.personalTraits;

    final List<String> advice = [];

    for (var trait in traits.keys) {
      if (!matchTraits.containsKey(trait)) continue;

      int uVal = traits[trait]!;
      int mVal = matchTraits[trait]!;
      int diff = (uVal - mVal).abs();

      String category = (diff > 1)
          ? 'diff'
          : (uVal >= 2 && mVal >= 2)
              ? 'high'
              : (uVal <= -2 && mVal <= -2)
                  ? 'low'
                  : 'neutral';

      if (_traitAdviceMap.containsKey(trait)) {
        final generated = _traitAdviceMap[trait]!.generateAdviceWithReason(
          isLongTerm,
          category,
        );
        if (generated.isNotEmpty) advice.add(generated);
      }
    }

    return advice;
  }
}

class TraitAdvice {
  final String name;
  final String traitLabel;
  final Map<String, String> datingAdvice;
  final Map<String, String> longTermAdvice;

  const TraitAdvice({
    required this.name,
    required this.traitLabel,
    required this.datingAdvice,
    required this.longTermAdvice,
  });

  String generateAdviceWithReason(bool isLongTerm, String category) {
    String reasonPrefix = switch (category) {
      'diff' => "You and your match differ in your levels of $traitLabel. ",
      'high' => "You both score highly on $traitLabel. ",
      'low'  => "You both have low levels of $traitLabel. ",
      _      => "",
    };

    String tip = isLongTerm
        ? longTermAdvice[category] ?? ""
        : datingAdvice[category] ?? "";

    return tip.isEmpty ? "" : "$reasonPrefix$tip";
  }
}

const Map<String, TraitAdvice> _traitAdviceMap = {
  "I enjoy socializing and being around people.": TraitAdvice(
    name: "Extroversion",
    traitLabel: "extroversion",
    datingAdvice: {
      'diff': "Consider dates that allow both alone time and group interaction, like a quiet dinner followed by a game night.",
      'high': "Use your shared energy to attend parties, group outings, or fun classes together.",
      'low': "Try peaceful settings like a quiet café, a bookstore, or a nature walk where conversation flows naturally.",
    },
    longTermAdvice: {
      'diff': "Discuss your social preferences and boundaries. Set expectations for how much socializing feels comfortable.",
      'high': "Plan a lifestyle that includes events, travel with friends, or a future full of social engagement.",
      'low': "Talk about how to recharge together and how you'll handle social obligations as a couple.",
    },
  ),
  "Having a family is a top priority for me.": TraitAdvice(
    name: "Family Orientation",
    traitLabel: "family orientation",
    datingAdvice: {
      'diff': "Do something that sparks value discussion: volunteer, attend a community event, or cook a traditional family recipe.",
      'high': "Bond over your shared goals with a date like visiting family, attending a wedding, or playing with kids at the park.",
      'low': "Explore alternatives like future travel goals, friendships-as-family, or creating chosen family dynamics.",
    },
    longTermAdvice: {
      'diff': "Have open conversations about future expectations around kids, caregiving, and balancing family priorities.",
      'high': "Discuss parenting values, family traditions, and where you want to raise a future family.",
      'low': "Plan for a future with autonomy or alternative ways to form deep support systems.",
    },
  ),
  "I like an active lifestyle with lots of physical activity.": TraitAdvice(
    name: "Activity Level",
    traitLabel: "activity level",
    datingAdvice: {
      'diff': "Balance differences with a walk followed by a relaxing activity like a movie or picnic.",
      'high': "Plan high-energy dates like hiking, climbing, or dance workouts together!",
      'low': "Opt for more chill dates like painting, café hopping, or exploring calm spots around campus.",
    },
    longTermAdvice: {
      'diff': "Clarify expectations around exercise, routine, and how physical activity fits into your lifestyle.",
      'high': "Set shared wellness goals, join fitness challenges, or plan future travel around active hobbies.",
      'low': "Plan a relaxing routine you both enjoy. Some suggestions include regular walks or yoga as stress relief.",
    },
  ),
  "I tend to stay calm and steady, even under pressure.": TraitAdvice(
    name: "Stress Tolerance",
    traitLabel: "stress tolerance",
    datingAdvice: {
      'diff': "Try a low-pressure activity and discuss how you each handle emotions under stress.",
      'high': "Tackle slightly challenging situations like escape rooms or team games where your calm shines.",
      'low': "Keep the mood light and avoid intense plans. A peaceful tea session or journaling together works best.",
    },
    longTermAdvice: {
      'diff': "Learn each other’s stress triggers and coping strategies to prevent miscommunication during tough times.",
      'high': "Talk about how to split responsibilities in high-stakes situations and be emotional anchors for each other.",
      'low': "Be proactive in developing healthy stress habits and emotional check-ins.",
    },
  ),
  "I love trying new things and taking risks.": TraitAdvice(
    name: "Openness",
    traitLabel: "openness to new experiences",
    datingAdvice: {
      'diff': "Pick a middle-ground adventure: something novel yet not too risky (e.g., new cuisine or class).",
      'high': "Plan an adrenaline-based outing: amusement parks, karaoke, or spontaneous travel!",
      'low': "Stick to familiar comforts: board games, hometown tours, or themed dinners.",
    },
    longTermAdvice: {
      'diff': "Discuss how adventurous each of you are about lifestyle changes, be it travel, jobs, or moving.",
      'high': "Design a future that includes big life shifts, travel dreams, or experimental projects.",
      'low': "Align on a slow-paced future and create comfort in stability, such as shared rituals and long-term routines.",
    },
  ),
};
