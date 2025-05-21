import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resources & Support',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildResourceCategory(context, 'Legal Support', [
                  ResourceItem(
                    title: 'Legal Aid Services',
                    description: 'Free legal consultation and representation',
                    icon: Icons.gavel,
                  ),
                  ResourceItem(
                    title: 'Rights & Laws',
                    description: 'Know your rights and legal protections',
                    icon: Icons.book,
                  ),
                  ResourceItem(
                    title: 'Documentation Help',
                    description: 'Assistance with legal documents',
                    icon: Icons.description,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildResourceCategory(context, 'Mental Health', [
                  ResourceItem(
                    title: 'Counseling Services',
                    description: 'Professional mental health support',
                    icon: Icons.psychology,
                  ),
                  ResourceItem(
                    title: 'Support Groups',
                    description: 'Connect with others in similar situations',
                    icon: Icons.people,
                  ),
                  ResourceItem(
                    title: 'Self-Care Resources',
                    description: 'Tools and techniques for well-being',
                    icon: Icons.spa,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildResourceCategory(context, 'Education & Career', [
                  ResourceItem(
                    title: 'Educational Programs',
                    description: 'Scholarships and learning opportunities',
                    icon: Icons.school,
                  ),
                  ResourceItem(
                    title: 'Career Development',
                    description: 'Job training and placement services',
                    icon: Icons.work,
                  ),
                  ResourceItem(
                    title: 'Skill Building',
                    description: 'Workshops and training programs',
                    icon: Icons.build,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildResourceCategory(context, 'Community Support', [
                  ResourceItem(
                    title: 'Local Organizations',
                    description: 'Community-based support services',
                    icon: Icons.location_city,
                  ),
                  ResourceItem(
                    title: 'Volunteer Opportunities',
                    description: 'Ways to give back to the community',
                    icon: Icons.volunteer_activism,
                  ),
                  ResourceItem(
                    title: 'Events & Workshops',
                    description: 'Upcoming community events',
                    icon: Icons.event,
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCategory(
    BuildContext context,
    String title,
    List<ResourceItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...items.map((item) => _buildResourceCard(context, item)),
      ],
    );
  }

  Widget _buildResourceCard(BuildContext context, ResourceItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(item.icon, color: AppTheme.primaryColor),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to resource details
        },
      ),
    );
  }
}

class ResourceItem {
  final String title;
  final String description;
  final IconData icon;

  ResourceItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
