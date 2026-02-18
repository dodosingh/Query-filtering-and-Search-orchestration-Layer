import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/search_bar.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;
  const SearchResultsPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Images', 'Videos', 'News', 'AI', 'Reviews'];
    final results = [
      {'title': 'Android Apps on Google Play', 'url': 'https://play.google.com/store'},
      {'title': 'Instagram', 'url': 'https://instagram.com'},
      {'title': 'Telegram', 'url': 'https://telegram.org'},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/logo/tech_search.png', height: 40, errorBuilder: (_, __, ___) {
              return const Text('Tech Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
            }),
            const SizedBox(width: 20),
            // Use a controller pre-filled with query
            Expanded(child: CustomSearchBar(controller: TextEditingController(text: query), showMic: true, whiteBackground: true)),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // filters
          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: ActionChip(
                  label: Text(filters[i]),
                  onPressed: () {},
                  backgroundColor: const Color(0xFF1A1A1A),
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white12),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) {
                final item = results[i];
                return ListTile(
                  title: Text(item['title']!, style: const TextStyle(color: Colors.blueAccent, fontSize: 16)),
                  subtitle: Text(item['url']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  onTap: () async {
                    final uri = Uri.parse(item['url']!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
