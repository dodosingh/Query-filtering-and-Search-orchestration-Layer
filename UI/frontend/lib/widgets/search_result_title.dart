import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResultTile extends StatelessWidget {
  final String title;
  final String description;
  final String link;

  const SearchResultTile({
    super.key,
    required this.title,
    required this.description,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(link)),
            child: Text(
              link,
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
