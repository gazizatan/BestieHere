import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/bestie_bottom_nav_bar.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).theme;
    final tips = [
      "Always trust your instincts and leave if you feel uncomfortable.",
      "Share your location with trusted friends or family.",
      "Avoid walking alone at night in unfamiliar areas.",
      "Keep your phone charged and accessible.",
      "Let someone know your plans and expected return time.",
      "Carry a personal safety alarm or whistle.",
      "Stay alert and avoid distractions like headphones in risky areas.",
      "Use well-lit and busy streets whenever possible.",
      "Don't accept rides from strangers.",
      "If you feel followed, go to a public place or approach a group.",
      "Keep emergency numbers on speed dial.",
      "Be cautious when sharing personal info online.",
      "Trust your gut about people and situations.",
      "If using a ride service, check the car and driver details.",
      "Keep your drink in sight at all times in public places.",
      "Learn basic self-defense moves.",
      "Have a code word with friends/family for emergencies.",
      "Don't hesitate to make noise or draw attention if threatened.",
      "If attacked, aim for sensitive areas (eyes, nose, groin).",
      "Remember: your safety is more important than your belongings.",
    ];
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Safety Tips for Girls'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView.separated(
          itemCount: tips.length,
          separatorBuilder: (context, i) => const SizedBox(height: 14),
          itemBuilder: (context, i) => Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: theme.secondaryColor.withOpacity(0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite, color: theme.primaryColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tips[i],
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 15,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BestieBottomNavBar(currentIndex: 2),
    );
  }
} 