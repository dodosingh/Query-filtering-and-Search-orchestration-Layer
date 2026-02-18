import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';


import '../widgets/search_bar.dart';

import '../widgets/shortcut_title.dart';
import 'results_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _shortcuts = [];

  @override
  void initState() {
    super.initState();
    _loadShortcuts();
  }

  Future<void> _loadShortcuts() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('shortcuts');
    if (saved != null) {
      _shortcuts = List<Map<String, String>>.from(jsonDecode(saved));
    } else {
      _shortcuts = [
        {"name": "YouTube", "url": "https://www.youtube.com", "icons": "assets/icons/image.png"},
        {"name": "ChatGPT", "url": "https://chat.openai.com", "icons": "assets/icons/ChatGPT_logo.svg.png"},
        {"name": "LeetCode", "url": "https://leetcode.com", "icons": "assets/icons/LeetCode_logo_black.png"},
      ];
    }
    setState(() {});
  }

  Future<void> _addShortcutDialog() async {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Add Shortcut', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Name', hintStyle: TextStyle(color: Colors.grey))),
            const SizedBox(height: 8),
            TextField(controller: urlCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'https://example.com', hintStyle: TextStyle(color: Colors.grey))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty && urlCtrl.text.isNotEmpty) {
                var url = urlCtrl.text.trim();
                if (!url.startsWith('http')) url = 'https://$url';
                _shortcuts.add({"name": nameCtrl.text.trim(), "url": url, "icon": ""});
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('shortcuts', jsonEncode(_shortcuts));
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsPage(query: query)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // if you have animated_background.dart, you can include it here as a Stack child
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/logo/Abtec Technology logo design - Aditya Chhatrala.jpeg', height: 80, errorBuilder: (_, __, ___) {
              return const Text('Tech Search', style: TextStyle(color: Color.fromARGB(255, 42, 159, 209), fontSize: 70,letterSpacing: 1.2, fontWeight: FontWeight.bold));
            }),
            const SizedBox(height: 20),

            // Search bar with mic
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomSearchBar(
                controller: _controller,
                hintText: 'Search tech innovations...',
                showMic: true,
                whiteBackground: true,
                onSubmitted: (_) => _search(),
              ),
            ),

            const SizedBox(height: 30),

            // Shortcuts grid
            Wrap(
              spacing: 20,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: [
                ..._shortcuts.map((s) => ShortcutTile(
                      name: s['name'] ?? '',
                      url: s['url'] ?? '',
                      iconPath: s['icon'] ?? '',
                    )),
                GestureDetector(
                  onTap: _addShortcutDialog,
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(height: 6),
                        Text('Add', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
