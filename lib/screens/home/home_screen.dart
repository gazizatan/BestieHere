import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../safe_places_screen.dart';
import '../contacts_screen.dart';
import '../safety_screen.dart';
import '../map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFA6C9), Color(0xFFFBC2EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33FFB6C1),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 36),
                        const SizedBox(width: 10),
                        Text(
                          'BestieHere',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ComicNeue',
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.pinkAccent.withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your personal safety companion',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.95),
                        fontFamily: 'ComicNeue',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Color(0xFFFFA6C9), size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontFamily: 'ComicNeue',
                                color: const Color(0xFFB23A48),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 1.1,
                      children: [
                        _buildActionCard(
                          context,
                          'Safe Places',
                          'Find nearby safe locations',
                          Icons.spa_rounded,
                          const Color(0xFFFFA6C9),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SafePlacesScreen(),
                            ),
                          ),
                          bgGradient: const [Color(0xFFFFE0F7), Color(0xFFFFA6C9)],
                          iconBg: const Color(0xFFFBC2EB),
                        ),
                        _buildActionCard(
                          context,
                          'Trusted Contacts',
                          'Manage your emergency contacts',
                          Icons.people_alt_rounded,
                          const Color(0xFFFBC2EB),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactsScreen(),
                            ),
                          ),
                          bgGradient: const [Color(0xFFFBC2EB), Color(0xFFFFA699)],
                          iconBg: const Color(0xFFFFA699),
                        ),
                        _buildActionCard(
                          context,
                          'Share Location',
                          'Share your location with trusted contacts',
                          Icons.favorite,
                          const Color(0xFFB23A48),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapScreen(),
                            ),
                          ),
                          bgGradient: const [Color(0xFFFFE0F7), Color(0xFFFBC2EB)],
                          iconBg: const Color(0xFFFFA699),
                        ),
                        _buildActionCard(
                          context,
                          'Safety Tips',
                          'Learn important safety measures',
                          Icons.star_rounded,
                          const Color(0xFFFFC2D1),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SafetyScreen(),
                            ),
                          ),
                          bgGradient: const [Color(0xFFFFC2D1), Color(0xFFFBC2EB)],
                          iconBg: const Color(0xFFFFA699),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Emergency Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement emergency action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA6C9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFFFA6C9).withOpacity(0.3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volunteer_activism, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'EMERGENCY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    List<Color>? bgGradient,
    Color? iconBg,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: bgGradient != null
                ? LinearGradient(
                    colors: bgGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconBg ?? color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Icon(
                  icon,
                  color: color,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'ComicNeue',
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: color.withOpacity(0.7),
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
