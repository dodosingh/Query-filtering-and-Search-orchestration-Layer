import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool showMic;
  final bool whiteBackground;
  final ValueChanged<String>? onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText,
    this.showMic = false,
    this.whiteBackground = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: whiteBackground ? Colors.white : Colors.grey[900],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: TextStyle(
                color: whiteBackground ? Colors.black : Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText ?? "Search...",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: whiteBackground ? Colors.grey[600] : Colors.grey[500],
                ),
              ),
            ),
          ),
          if (showMic)
            IconButton(
              icon: Icon(
                Icons.mic,
                color: whiteBackground ? Colors.grey[700] : Colors.grey,
                size: 22,
              ),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}
