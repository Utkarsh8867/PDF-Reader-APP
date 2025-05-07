// import 'package:pdf_reader/screens/PremiumPlanScreen.dart';
// import 'package:pdf_reader/screens/jee_voice_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/history_storage.dart';
// import 'jee_chat_interface.dart';

// class JEEChatScreen extends StatefulWidget {
//   const JEEChatScreen({super.key});

//   @override
//   State<JEEChatScreen> createState() => _JEEChatScreenState();
// }

// class _JEEChatScreenState extends State<JEEChatScreen> {
//   List<String> _history = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//   }

//   Future<void> _loadHistory() async {
//     try {
//       final history = await HistoryStorage().getHistory();
//       setState(() {
//         _history = history;
//       });
//     } catch (e) {
//       print('Failed to load history: $e');
//       setState(() {
//         _history = [];
//       });
//     }
//   }

//   void _openChatWithPrompt(String? prompt) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => JEEChatInterface(initialPrompt: prompt),
//       ),
//     ).then((_) => _loadHistory());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildPremiumPlanSection(),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   _buildFeatureCard(
//                     "Chat with UGPT",
//                     Icons.chat,
//                     Colors.purple,
//                   ),
//                   const SizedBox(width: 16),
//                   _buildFeatureCard("Talk with UGPT", Icons.mic, Colors.yellow),
//                 ],
//               ),
//               const SizedBox(height: 28),
//               _buildTopicsSection(),
//               const SizedBox(height: 28),
//               _buildHistorySection(),
//               const SizedBox(height: 16),
//               _buildHistoryList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumPlanSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.deepPurple, Colors.pink]),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purpleAccent.withOpacity(0.5),
//             blurRadius: 12,
//             spreadRadius: 1,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "UPLOAD FILES", // Capitalized to make it bolder
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 24, // Larger text
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "Upload any type's of\nfile like Docs \nPDF and Text files.",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white70,
//                     fontSize: 13, // Smaller text for contrast
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to PremiumPlanScreen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PremiumPlanScreen()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.yellow,
//               foregroundColor: Colors.black,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               textStyle: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             child: const Text("Upgrade"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopicsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionTitle("Topics"),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildAnimatedTopic(
//               "web\nDevelopment",
//               Icons.web,
//               Colors.green,
//               "Web development all skills",
//             ),
//             _buildAnimatedTopic(
//               "Android\nDevelopment",
//               Icons.bubble_chart,
//               Colors.pink,
//               "Android development all skills",
//             ),
//             _buildAnimatedTopic(
//               "Devops",
//               Icons.developer_board,
//               // Icons.calculate,
//               Colors.blue,
//               "DevOps skill and requirements",
//             ),
//             _buildAnimatedTopic(
//               "DSA",
//               Icons.business,
//               Colors.purple,
//               "DSA in Java Language",
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildHistorySection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _sectionTitle("History"),
//         TextButton(
//           onPressed: () async {
//             await HistoryStorage().clearHistory();
//             _loadHistory();
//           },
//           child: Text(
//             "Clear History",
//             style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHistoryList() {
//     return Expanded(
//       child:
//           _history.isEmpty
//               ? Center(
//                 child: Text(
//                   "No history yet.",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               )
//               : AnimationLimiter(
//                 child: ListView.builder(
//                   itemCount: _history.length,
//                   itemBuilder: (context, index) {
//                     final prompt = _history[index];
//                     return AnimationConfiguration.staggeredList(
//                       position: index,
//                       duration: const Duration(milliseconds: 500),
//                       child: SlideAnimation(
//                         verticalOffset: 50.0,
//                         child: FadeInAnimation(
//                           child: GestureDetector(
//                             onTap: () => _openChatWithPrompt(prompt),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               margin: const EdgeInsets.only(bottom: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.deepPurple.shade900.withOpacity(
//                                   0.8,
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(color: Colors.white30),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 10,
//                                     offset: Offset(0, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 prompt,
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//     );
//   }

//   Widget _buildFeatureCard(String title, IconData icon, Color iconColor) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           if (title == "Chat with UGPT") {
//             _openChatWithPrompt(null);
//           } else {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => VoiceAssistantScreen()),
//             );
//           }
//         },
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey[900],
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
//           ),
//           child: Column(
//             children: [
//               Icon(icon, color: iconColor, size: 48),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedTopic(
//     String label,
//     IconData icon,
//     Color color,
//     String prompt,
//   ) {
//     return GestureDetector(
//       onTap: () => _openChatWithPrompt(prompt),
//       child: Column(
//         children: [
//           Animate(
//             effects: [
//               ScaleEffect(
//                 delay: 100.ms,
//                 duration: 400.ms,
//                 curve: Curves.elasticOut,
//               ),
//             ],
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey[850],
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.6),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Icon(icon, color: color, size: 30),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             label,
//             style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Text(
//       title,
//       style: GoogleFonts.poppins(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../services/history_storage.dart';
// import 'jee_chat_interface.dart';
// import 'jee_voice_screen.dart';
// import 'PremiumPlanScreen.dart';

// class JEEChatScreen extends StatefulWidget {
//   const JEEChatScreen({super.key});

//   @override
//   State<JEEChatScreen> createState() => _JEEChatScreenState();
// }

// class _JEEChatScreenState extends State<JEEChatScreen> {
//   List<String> _history = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//   }

//   Future<void> _loadHistory() async {
//     try {
//       final history = await HistoryStorage().getHistory();
//       setState(() {
//         _history = history;
//       });
//     } catch (e) {
//       print('Failed to load history: $e');
//       setState(() {
//         _history = [];
//       });
//     }
//   }

//   void _openChatWithPrompt(String? prompt) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => JEEChatInterface(initialPrompt: prompt),
//       ),
//     ).then((_) => _loadHistory());
//   }

//   void _launchGitHub() async {
//     final url = Uri.parse("https://github.com/Utkarsh8867");
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Text(
//           'JEE Assistant',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.code, color: Colors.white),
//             onPressed: _launchGitHub,
//             tooltip: "GitHub Profile",
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildPremiumPlanSection(),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   _buildFeatureCard(
//                     "Chat with UGPT",
//                     Icons.chat,
//                     Colors.purple,
//                   ),
//                   const SizedBox(width: 16),
//                   _buildFeatureCard("Talk with UGPT", Icons.mic, Colors.yellow),
//                 ],
//               ),
//               const SizedBox(height: 28),
//               _buildTopicsSection(),
//               const SizedBox(height: 28),
//               _buildHistorySection(),
//               const SizedBox(height: 16),
//               _buildHistoryList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumPlanSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Colors.deepPurple, Colors.pink],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purpleAccent.withOpacity(0.5),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "UPLOAD FILES",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "Upload files like Docs, PDF, or Text files.",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white70,
//                     fontSize: 13,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PremiumPlanScreen()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.yellow,
//               foregroundColor: Colors.black,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text("Upgrade"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeatureCard(String title, IconData icon, Color iconColor) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           if (title == "Chat with UGPT") {
//             _openChatWithPrompt(null);
//           } else {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => VoiceAssistantScreen()),
//             );
//           }
//         },
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey[900],
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
//           ),
//           child: Column(
//             children: [
//               Icon(icon, color: iconColor, size: 40),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopicsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionTitle("Topics"),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildAnimatedTopic(
//               "web\nDevelopment",
//               Icons.web,
//               Colors.green,
//               "Web development all skills",
//             ),
//             _buildAnimatedTopic(
//               "Android\nDevelopment",
//               Icons.android,
//               Colors.pink,
//               "Android development all skills",
//             ),
//             _buildAnimatedTopic(
//               "DevOps",
//               Icons.settings,
//               Colors.blue,
//               "DevOps skill and requirements",
//             ),
//             _buildAnimatedTopic(
//               "DSA",
//               Icons.code,
//               Colors.purple,
//               "DSA in Java Language",
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAnimatedTopic(
//     String label,
//     IconData icon,
//     Color color,
//     String prompt,
//   ) {
//     return GestureDetector(
//       onTap: () => _openChatWithPrompt(prompt),
//       child: Column(
//         children: [
//           Animate(
//             effects: [
//               ScaleEffect(
//                 delay: 100.ms,
//                 duration: 400.ms,
//                 curve: Curves.elasticOut,
//               ),
//             ],
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey[850],
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.6),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Icon(icon, color: color, size: 28),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistorySection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _sectionTitle("History"),
//         TextButton(
//           onPressed: () async {
//             await HistoryStorage().clearHistory();
//             _loadHistory();
//           },
//           child: Text(
//             "Clear History",
//             style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHistoryList() {
//     return Expanded(
//       child:
//           _history.isEmpty
//               ? Center(
//                 child: Text(
//                   "No history yet.",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               )
//               : AnimationLimiter(
//                 child: ListView.builder(
//                   itemCount: _history.length,
//                   itemBuilder: (context, index) {
//                     final prompt = _history[index];
//                     return AnimationConfiguration.staggeredList(
//                       position: index,
//                       duration: const Duration(milliseconds: 500),
//                       child: SlideAnimation(
//                         verticalOffset: 50.0,
//                         child: FadeInAnimation(
//                           child: GestureDetector(
//                             onTap: () => _openChatWithPrompt(prompt),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               margin: const EdgeInsets.only(bottom: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.deepPurple.shade900.withOpacity(
//                                   0.8,
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(color: Colors.white30),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 10,
//                                     offset: Offset(0, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 prompt,
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Text(
//       title,
//       style: GoogleFonts.poppins(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/history_storage.dart';
import 'jee_chat_interface.dart';
import 'jee_voice_screen.dart';
import 'PremiumPlanScreen.dart';

class JEEChatScreen extends StatefulWidget {
  const JEEChatScreen({super.key});

  @override
  State<JEEChatScreen> createState() => _JEEChatScreenState();
}

class _JEEChatScreenState extends State<JEEChatScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await HistoryStorage().getHistory();
      setState(() {
        _history = history;
      });
    } catch (e) {
      print('Failed to load history: $e');
      setState(() {
        _history = [];
      });
    }
  }

  void _openChatWithPrompt(String? prompt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JEEChatInterface(initialPrompt: prompt),
      ),
    ).then((_) => _loadHistory());
  }

  void _launchGitHub() async {
    final url = Uri.parse("https://github.com/Utkarsh8867/PDF-Reader-APP");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.pink],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UGPT Assistant',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Version v1.0.0',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.upgrade, color: Colors.yellow),
              title: Text(
                'Upgrade Plan',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PremiumPlanScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.code, color: Colors.white),
              title: Text(
                'GitHub Profile',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: _launchGitHub,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'UGPT Assistant',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              "v1.0.0",
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumPlanSection(),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildFeatureCard(
                    "Chat with UGPT",
                    Icons.chat,
                    Colors.purple,
                  ),
                  const SizedBox(width: 16),
                  _buildFeatureCard("Talk with UGPT", Icons.mic, Colors.yellow),
                ],
              ),
              const SizedBox(height: 28),
              _buildTopicsSection(),
              const SizedBox(height: 28),
              _buildHistorySection(),
              const SizedBox(height: 16),
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumPlanSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.yellowAccent, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Unlock premium features to boost your Skills !",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PremiumPlanScreen()),
              );
            },
            child: Text(
              "Upgrade",
              style: GoogleFonts.poppins(color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (title.contains("Chat")) {
            _openChatWithPrompt(null);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VoiceAssistantScreen()),
            );
          }
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicsSection() {
    final topics = ["Web Development", "Android Development", "Devops", "DSA"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Topics",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children:
              topics.map((topic) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () => _openChatWithPrompt(topic),
                  child: Text(
                    topic,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Text(
      "Your Past Chats",
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return Text(
        "No history yet.",
        style: GoogleFonts.poppins(color: Colors.white70),
      );
    }

    return Expanded(
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: _history.length,
          itemBuilder: (context, index) {
            final prompt = _history[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        prompt,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      onTap: () => _openChatWithPrompt(prompt),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
