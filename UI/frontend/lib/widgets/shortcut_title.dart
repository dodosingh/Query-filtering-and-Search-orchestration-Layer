import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShortcutTile extends StatelessWidget {
  final String name;
  final String url;
  final String iconPath;

  const ShortcutTile({
    super.key,
    required this.name,
    required this.url,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid URL')));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
              image: iconPath.isNotEmpty ? DecorationImage(image: AssetImage(iconPath), fit: BoxFit.cover) : null,
            ),
            child: iconPath.isEmpty ? const Icon(Icons.language, color: Colors.white) : null,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
