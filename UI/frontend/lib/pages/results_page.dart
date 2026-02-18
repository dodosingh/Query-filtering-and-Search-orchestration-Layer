import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<dynamic> _realResults = [];
  String _improvedQuery = ""; // Store the AI-optimized query
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTechResults();
  }

  Future<void> _fetchTechResults() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Replace with your current IP. 
    // Use "10.0.2.2" for Android Emulator or "localhost" for iOS Simulator
    const String backendIp = "10.45.220.58"; 
    final url = Uri.parse('http://$backendIp:8000/search');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": widget.query}),
      ).timeout(const Duration(seconds: 15)); // Add timeout for safety

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          setState(() {
            _realResults = data['results'];
            _improvedQuery = data['improved_query'] ?? "";
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = data['message']; 
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network Error: Please check if the backend is running at $backendIp";
        _isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Tech Insights", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTechResults, // Allow manual retry
          )
        ],
      ),
      body: _isLoading
          ? _buildLoadingUI()
          : _errorMessage != null
              ? _buildErrorUI()
              : _buildResultsList(),
    );
  }

  Widget _buildLoadingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.deepPurpleAccent),
          const SizedBox(height: 20),
          Text("Optimizing query for ${widget.query}...", 
               style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gpp_maybe_outlined, color: Colors.redAccent, size: 60),
            const SizedBox(height: 20),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: const Text("Go Back"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_realResults.isEmpty) {
      return const Center(
        child: Text("No technical documentation found for this query.", 
                   style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show the user the improved AI query
        if (_improvedQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              "AI Optimized: \"$_improvedQuery\"",
              style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _realResults.length,
            itemBuilder: (context, index) {
              final result = _realResults[index];
              return _buildResultCard(result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(dynamic result) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _launchURL(result["url"]),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result["title"] ?? "Untitled",
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                result["snippet"] ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.link, color: Colors.deepPurpleAccent, size: 16),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      result["url"],
                      style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http; // Make sure to run 'flutter pub add http'
// import 'dart:convert';

// class SearchResultsPage extends StatefulWidget {
//   final String query;

//   const SearchResultsPage({super.key, required this.query});

//   @override
//   State<SearchResultsPage> createState() => _SearchResultsPageState();
// }

// class _SearchResultsPageState extends State<SearchResultsPage> {
//   List<dynamic> _realResults = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchTechResults();
//   }

//   Future<void> _fetchTechResults() async {
//     // 1. FIND YOUR LOCAL IP (via ipconfig) and replace '192.168.1.10'
//     // If using Android Emulator, use '10.0.2.2'
//     const String backendIp = "192.168.1.10"; 
//     final url = Uri.parse('http://$backendIp:8000/search');

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"query": widget.query}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'success') {
//           setState(() {
//             _realResults = data['results'];
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage = data['message']; // The "NON_TECH" message
//             _isLoading = false;
//           });
//         }
//       } else {
//         throw Exception("Server Error");
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Could not connect to backend. Make sure it's running!";
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           "Results for \"${widget.query}\"",
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
//           : _errorMessage != null
//               ? _buildErrorUI()
//               : _buildResultsList(),
//     );
//   }

//   Widget _buildErrorUI() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(
//           _errorMessage!,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }

//   Widget _buildResultsList() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: ListView.builder(
//         itemCount: _realResults.length,
//         itemBuilder: (context, index) {
//           final result = _realResults[index];
//           return GestureDetector(
//             onTap: () => _launchURL(result["url"]!),
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A1A1A),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.deepPurpleAccent.withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     result["title"]!,
//                     style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     result["snippet"]!,
//                     style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     result["url"]!,
//                     style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 13, decoration: TextDecoration.underline),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }









































































// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SearchResultsPage extends StatelessWidget {
//   final String query;

//   const SearchResultsPage({super.key, required this.query});

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Dummy results
//     final List<Map<String, String>> dummyResults = [
//       {
//         "title": "Apple's Latest M3 Chip Revolutionizes Performance",
//         "description": "Discover how Apple’s M3 chip is setting new standards in efficiency and AI-driven computing.",
//         "url": "https://www.techcrunch.com/apple-m3-chip"
//       },
//       {
//         "title": "GSM Arena Reviews the Samsung Galaxy S25 Ultra",
//         "description": "A complete breakdown of Samsung’s newest flagship — specs, camera, and more.",
//         "url": "https://www.gsmarena.com/samsung_galaxy_s25_ultra_review"
//       },
//       {
//         "title": "AI in Everyday Devices: The Next Big Leap",
//         "description": "TechRadar explores how AI integration is changing the way we interact with gadgets.",
//         "url": "https://www.techradar.com/ai-devices-future"
//       },
//       {
//         "title": "Tesla’s New Cybertruck — Built for the Future",
//         "description": "Elon Musk unveils the redesigned Cybertruck — now with smarter sensors and cleaner energy use.",
//         "url": "https://www.theverge.com/tesla-cybertruck-2025"
//       },
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           "Results for \"$query\"",
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: ListView.builder(
//           itemCount: dummyResults.length,
//           itemBuilder: (context, index) {
//             final result = dummyResults[index];
//             return GestureDetector(
//               onTap: () => _launchURL(result["url"]!),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1A1A1A),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.deepPurpleAccent.withOpacity(0.2),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       result["title"]!,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.1,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       result["description"]!,
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       result["url"]!,
//                       style: const TextStyle(
//                         color: Colors.deepPurpleAccent,
//                         fontSize: 13,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
