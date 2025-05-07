// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../services/chatbot_api_service.dart';

// class VoiceAssistantScreen extends StatefulWidget {
//   @override
//   State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
// }

// class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();
//   final ChatbotApiService _chatbotService = ChatbotApiService();

//   String _spokenText = "";
//   String _responseText = "";
//   bool _isListening = false;
//   bool _isLoadingResponse = false;
//   bool _isSpeaking = false;

//   @override
//   void initState() {
//     super.initState();
//     _initTTS();
//   }

//   // Future<void> _initTTS() async {
//   //   await _flutterTts.setLanguage("en-US");
//   //   await _flutterTts.setSpeechRate(0.5);
//   //   await _flutterTts.setPitch(1.0);
//   //   _flutterTts.setCompletionHandler(() {
//   //     setState(() {
//   //       _isSpeaking = false;
//   //     });
//   //   });
//   // }

// Future<void> _initTTS() async {
//   try {
//     await _flutterTts.awaitSpeakCompletion(true);
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setPitch(1.0);
//   } catch (e) {
//     print("TTS Initialization Error: $e");
//   }
// }
//   void _startListening() async {
//     try {
//       bool available = await _speechToText.initialize();

//       if (available) {
//         setState(() {
//           _isListening = true;
//           _spokenText = "";
//           _responseText = "";
//         });

//         _speechToText.listen(
//           onResult: (result) {
//             setState(() {
//               _spokenText = result.recognizedWords;
//             });
//           },
//         );
//       } else {
//         setState(() {
//           _spokenText = "⚠️ Your device does not support speech recognition.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _spokenText =
//             "⚠️ Unable to access your microphone.\nPlease check app permissions or your device settings.";
//       });
//       print("SpeechToText Plugin Error: $e");
//     }
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//     });

//     if (_spokenText.isNotEmpty) {
//       _fetchChatbotResponse(_spokenText);
//     }
//   }

//   Future<void> _fetchChatbotResponse(String prompt) async {
//     setState(() {
//       _isLoadingResponse = true;
//     });

//     try {
//       final response = await _chatbotService.fetchJEEAnswer(prompt);
//       setState(() {
//         _responseText = response;
//         _speakResponse(response);
//       });
//     } catch (e) {
//       setState(() {
//         _responseText =
//             "⚠️ Failed to fetch response. Please check your internet connection.";
//       });
//     } finally {
//       setState(() {
//         _isLoadingResponse = false;
//       });
//     }
//   }

//   void _speakResponse(String text) async {
//     setState(() {
//       _isSpeaking = true;
//     });

//     await _flutterTts.speak(text);
//   }

//   void _stopSpeaking() async {
//     await _flutterTts.stop();
//     setState(() {
//       _isSpeaking = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Talking to JEE Bot",
//           style: GoogleFonts.poppins(fontSize: 18),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             _isListening ? "Listening..." : "Tap the mic to speak",
//             style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
//           ),
//           const SizedBox(height: 20),

//           // Speaking animation
//           if (_isSpeaking) _buildSpeakingAnimation(),

//           const SizedBox(height: 30),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Text(
//               _spokenText.isNotEmpty
//                   ? 'You said: $_spokenText'
//                   : 'Press the mic and ask your question.',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),

//           if (_isLoadingResponse)
//             const CircularProgressIndicator(color: Colors.blue)
//           else if (_responseText.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Text(
//                 "JEE Bot: $_responseText",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Colors.greenAccent,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//           const SizedBox(height: 40),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 🎤 Mic Button
//               IconButton(
//                 iconSize: 80,
//                 icon: Icon(
//                   _isListening ? Icons.mic_off : Icons.mic,
//                   color: _isListening ? Colors.redAccent : Colors.white,
//                 ),
//                 onPressed: _isListening ? _stopListening : _startListening,
//               ),

//               const SizedBox(width: 20),

//               // 🛑 Stop Button (Only visible if speaking)
//               if (_isSpeaking)
//                 IconButton(
//                   iconSize: 80,
//                   icon: const Icon(Icons.stop_circle, color: Colors.red),
//                   onPressed: _stopSpeaking,
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // 🎶 Speaking Animation Effect
//   Widget _buildSpeakingAnimation() {
//     return Container(
//           width: 150,
//           height: 150,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: RadialGradient(
//               colors: [
//                 Colors.blueAccent,
//                 Colors.greenAccent,
//                 Colors.purpleAccent,
//               ],
//             ),
//           ),
//         )
//         .animate(onComplete: (controller) => controller.repeat())
//         .scale(duration: 1.seconds)
//         .fadeOut(duration: 1.seconds);
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../services/chatbot_api_service.dart';

// class VoiceAssistantScreen extends StatefulWidget {
//   @override
//   State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
// }

// class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();
//   final ChatbotApiService _chatbotService = ChatbotApiService();
//   final TextEditingController _textController = TextEditingController();

//   String _spokenText = "";
//   String _responseText = "";
//   bool _isListening = false;
//   bool _isLoadingResponse = false;
//   bool _isSpeaking = false;

//   @override
//   void initState() {
//     super.initState();
//     _initTTS();
//   }

//   Future<void> _initTTS() async {
//     await _flutterTts.awaitSpeakCompletion(true);
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setPitch(1.0);
//   }

//   void _startListening() async {
//     bool available = await _speechToText.initialize();
//     if (available) {
//       setState(() {
//         _isListening = true;
//         _spokenText = "";
//         _responseText = "";
//       });

//       _speechToText.listen(
//         onResult: (result) {
//           setState(() {
//             _spokenText = result.recognizedWords;
//           });
//         },
//       );
//     }
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//     });

//     if (_spokenText.isNotEmpty) {
//       _fetchChatbotResponse(_spokenText);
//     }
//   }

//   Future<void> _fetchChatbotResponse(String prompt) async {
//     setState(() {
//       _isLoadingResponse = true;
//     });

//     try {
//       final response = await _chatbotService.fetchJEEAnswer(prompt);
//       setState(() {
//         _responseText = response;
//         _speakResponse(response);
//       });
//     } catch (e) {
//       setState(() {
//         _responseText = "⚠️ Failed to fetch response.";
//       });
//     } finally {
//       setState(() {
//         _isLoadingResponse = false;
//       });
//     }
//   }

//   void _speakResponse(String text) async {
//     setState(() {
//       _isSpeaking = true;
//     });
//     await _flutterTts.speak(text);
//   }

//   void _stopSpeaking() async {
//     await _flutterTts.stop();
//     setState(() {
//       _isSpeaking = false;
//     });
//   }

//   void _sendTypedQuery() {
//     String textPrompt = _textController.text.trim();
//     if (textPrompt.isNotEmpty) {
//       _textController.clear();
//       setState(() {
//         _spokenText = textPrompt;
//         _responseText = "";
//       });
//       _fetchChatbotResponse(textPrompt);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text("Talking to JEE Bot",
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               color: Colors.white,
//             )),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1D1E33), Color(0xFF111328)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: LayoutBuilder(builder: (context, constraints) {
//             return GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: SingleChildScrollView(
//                 reverse: true,
//                 padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom + 20),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Chat messages area
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               if (_spokenText.isNotEmpty)
//                                 _buildChatBubble(_spokenText, true),
//                               const SizedBox(height: 12),
//                               if (_isLoadingResponse)
//                                 const CircularProgressIndicator(color: Colors.blueAccent)
//                               else if (_responseText.isNotEmpty)
//                                 _buildChatBubble(_responseText, false),
//                             ],
//                           ),
//                         ),

//                         // Mic and Text Input
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: _isListening ? _stopListening : _startListening,
//                                     child: Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         gradient: const LinearGradient(
//                                           colors: [Colors.blueAccent, Colors.cyan],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.cyan.withOpacity(0.6),
//                                             blurRadius: 20,
//                                             offset: const Offset(0, 8),
//                                           )
//                                         ],
//                                       ),
//                                       child: Icon(
//                                         _isListening ? Icons.mic_off : Icons.mic,
//                                         size: 40,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   if (_isSpeaking)
//                                     IconButton(
//                                       icon: const Icon(Icons.stop_circle, color: Colors.red, size: 40),
//                                       onPressed: _stopSpeaking,
//                                     ),
//                                 ],
//                               ),
//                               const SizedBox(height: 20),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(30),
//                                       ),
//                                       child: TextField(
//                                         controller: _textController,
//                                         style: const TextStyle(color: Colors.white),
//                                         decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Type your question...',
//                                           hintStyle: TextStyle(color: Colors.white54),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   GestureDetector(
//                                     onTap: _isLoadingResponse ? null : _sendTypedQuery,
//                                     child: Container(
//                                       padding: const EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blueAccent,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(Icons.send, color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _buildChatBubble(String text, bool isUser) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         padding: const EdgeInsets.all(14),
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blueAccent : Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//             bottomLeft: Radius.circular(isUser ? 16 : 0),
//             bottomRight: Radius.circular(isUser ? 0 : 16),
//           ),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.poppins(
//             color: isUser ? Colors.white : Colors.greenAccent,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../services/chatbot_api_service.dart';

// class VoiceAssistantScreen extends StatefulWidget {
//   @override
//   State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
// }

// class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();
//   final ChatbotApiService _chatbotService = ChatbotApiService();
//   final TextEditingController _textController = TextEditingController();

//   String _spokenText = "";
//   String _responseText = "";
//   bool _isListening = false;
//   bool _isLoadingResponse = false;
//   bool _isSpeaking = false;

//   @override
//   void initState() {
//     super.initState();
//     _initTTS();
//   }

//   Future<void> _initTTS() async {
//     await _flutterTts.awaitSpeakCompletion(true);
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setPitch(1.0);
//   }

//   void _startListening() async {
//     bool available = await _speechToText.initialize();
//     if (available) {
//       setState(() {
//         _isListening = true;
//         _spokenText = "";
//         _responseText = "";
//       });

//       _speechToText.listen(
//         onResult: (result) {
//           setState(() {
//             _spokenText = result.recognizedWords;
//           });
//         },
//       );
//     }
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//     });

//     if (_spokenText.isNotEmpty) {
//       _fetchChatbotResponse(_spokenText);
//     }
//   }

//   Future<void> _fetchChatbotResponse(String prompt) async {
//     setState(() {
//       _isLoadingResponse = true;
//     });

//     try {
//       final response = await _chatbotService.fetchJEEAnswer(prompt);
//       setState(() {
//         _responseText = response;
//         _speakResponse(response);
//       });
//     } catch (e) {
//       setState(() {
//         _responseText = "⚠️ Failed to fetch response.";
//       });
//     } finally {
//       setState(() {
//         _isLoadingResponse = false;
//       });
//     }
//   }

//   void _speakResponse(String text) async {
//     setState(() {
//       _isSpeaking = true;
//     });
//     await _flutterTts.speak(text);
//   }

//   void _stopSpeaking() async {
//     await _flutterTts.stop();
//     setState(() {
//       _isSpeaking = false;
//     });
//   }

//   void _sendTypedQuery() {
//     String textPrompt = _textController.text.trim();
//     if (textPrompt.isNotEmpty) {
//       _textController.clear();
//       setState(() {
//         _spokenText = textPrompt;
//         _responseText = "";
//       });
//       _fetchChatbotResponse(textPrompt);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F2027),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           "🧠 UGPT Voice Assistant",
//           style: GoogleFonts.poppins(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.cyanAccent,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   if (_spokenText.isNotEmpty)
//                     _buildChatBubble(
//                       _spokenText,
//                       true,
//                     ).animate().slideX(duration: 400.ms),
//                   if (_isLoadingResponse)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         child: CircularProgressIndicator(
//                           color: Colors.cyanAccent,
//                         ),
//                       ),
//                     ),
//                   if (_responseText.isNotEmpty)
//                     _buildChatBubble(
//                       _responseText,
//                       false,
//                     ).animate().fadeIn(duration: 500.ms),
//                 ],
//               ),
//             ),
//             _buildInputSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChatBubble(String text, bool isUser) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color:
//               isUser
//                   ? Colors.cyanAccent.withOpacity(0.2)
//                   : Colors.white.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isUser ? Colors.cyanAccent : Colors.greenAccent,
//             width: 1,
//           ),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             color: isUser ? Colors.white : Colors.greenAccent,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1F1F2D),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(26),
//           topRight: Radius.circular(26),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black45,
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _textController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white12,
//                     hintText: 'Ask me anything about ...',
//                     hintStyle: const TextStyle(color: Colors.white54),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 14,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               GestureDetector(
//                 onTap: _isLoadingResponse ? null : _sendTypedQuery,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.cyanAccent,
//                   child: const Icon(Icons.send, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: _isListening ? _stopListening : _startListening,
//                 child: CircleAvatar(
//                   radius: 30,
//                   backgroundColor: _isListening ? Colors.red : Colors.cyan,
//                   child: Icon(
//                     _isListening ? Icons.stop : Icons.mic,
//                     size: 30,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 30),
//               if (_isSpeaking)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.volume_off,
//                     color: Colors.redAccent,
//                     size: 36,
//                   ),
//                   onPressed: _stopSpeaking,
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../services/chatbot_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VoiceAssistantScreen extends StatefulWidget {
  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final ChatbotApiService _chatbotService = ChatbotApiService();
  final TextEditingController _textController = TextEditingController();

  String _spokenText = "";
  String _responseText = "";
  bool _isListening = false;
  bool _isLoadingResponse = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _spokenText = "";
        _responseText = "";
      });

      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
    if (_spokenText.isNotEmpty) {
      _fetchChatbotResponse(_spokenText);
    }
  }

  Future<void> _fetchChatbotResponse(String prompt) async {
    setState(() => _isLoadingResponse = true);
    try {
      final response = await _chatbotService.fetchJEEAnswer(prompt);
      setState(() {
        _responseText = response;
        _speakResponse(response);
      });
    } catch (e) {
      setState(() {
        _responseText = "⚠️ Failed to fetch response.";
      });
    } finally {
      setState(() => _isLoadingResponse = false);
    }
  }

  void _speakResponse(String text) async {
    setState(() => _isSpeaking = true);
    await _flutterTts.speak(text);
  }

  void _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() => _isSpeaking = false);
  }

  void _sendTypedQuery() {
    String textPrompt = _textController.text.trim();
    if (textPrompt.isNotEmpty) {
      _textController.clear();
      setState(() {
        _spokenText = textPrompt;
        _responseText = "";
      });
      _fetchChatbotResponse(textPrompt);
    }
  }

  void _launchGitHub() async {
    final Uri url = Uri.parse("https://github.com/Utkarsh8867");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic_rounded, color: Colors.cyanAccent),
            const SizedBox(width: 8),
            Text(
              "UGPT Voice Assistant",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.code, color: Colors.cyanAccent),
            tooltip: 'GitHub',
            onPressed: _launchGitHub,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_spokenText.isNotEmpty)
                    _buildChatBubble(
                      _spokenText,
                      true,
                    ).animate().slideX(duration: 400.ms),
                  if (_isLoadingResponse)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ),
                  if (_responseText.isNotEmpty)
                    _buildChatBubble(
                      _responseText,
                      false,
                    ).animate().fadeIn(duration: 500.ms),
                ],
              ),
            ),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              isUser
                  ? Colors.cyanAccent.withOpacity(0.2)
                  : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 18),
          ),
          border: Border.all(
            color: isUser ? Colors.cyanAccent : Colors.greenAccent,
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isUser ? Colors.white : Colors.greenAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2D),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    hintText: 'Type your question...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _isLoadingResponse ? null : _sendTypedQuery,
                child: CircleAvatar(
                  backgroundColor: Colors.cyanAccent,
                  child: const Icon(Icons.send, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: _isListening ? Colors.red : Colors.cyan,
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              if (_isSpeaking)
                IconButton(
                  icon: const Icon(
                    Icons.volume_off,
                    color: Colors.redAccent,
                    size: 36,
                  ),
                  onPressed: _stopSpeaking,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/services.dart'; // For Clipboard
// import '../services/chatbot_api_service.dart';

// class VoiceAssistantScreen extends StatefulWidget {
//   @override
//   State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
// }

// class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();
//   final ChatbotApiService _chatbotService = ChatbotApiService();
//   final TextEditingController _textController = TextEditingController();

//   bool _isListening = false;
//   bool _isLoadingResponse = false;
//   bool _isSpeaking = false;
//   String _spokenText = "";
//   String _responseText = "";

//   List<Map<String, String>> _conversation = [];

//   @override
//   void initState() {
//     super.initState();
//     _initTTS();
//   }

//   Future<void> _initTTS() async {
//     await _flutterTts.awaitSpeakCompletion(true);
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setPitch(1.0);
//   }

//   void _startListening() async {
//     bool available = await _speechToText.initialize();
//     if (available) {
//       setState(() {
//         _isListening = true;
//         _spokenText = "";
//         _responseText = "";
//       });

//       _speechToText.listen(
//         onResult: (result) {
//           setState(() {
//             _spokenText = result.recognizedWords;
//           });
//         },
//       );
//     }
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//     });

//     if (_spokenText.isNotEmpty) {
//       _fetchChatbotResponse(_spokenText);
//     }
//   }

//   Future<void> _fetchChatbotResponse(String prompt) async {
//     setState(() {
//       _isLoadingResponse = true;
//       _conversation.add({'role': 'user', 'text': prompt});
//     });

//     try {
//       final response = await _chatbotService.fetchJEEAnswer(prompt);
//       setState(() {
//         _responseText = response;
//         _conversation.add({'role': 'bot', 'text': response});
//         _speakResponse(response);
//       });
//     } catch (e) {
//       setState(() {
//         _responseText = "⚠️ Failed to fetch response.";
//         _conversation.add({'role': 'bot', 'text': _responseText});
//       });
//     } finally {
//       setState(() {
//         _isLoadingResponse = false;
//       });
//     }
//   }

//   void _speakResponse(String text) async {
//     setState(() {
//       _isSpeaking = true;
//     });
//     await _flutterTts.speak(text);
//   }

//   void _stopSpeaking() async {
//     await _flutterTts.stop();
//     setState(() {
//       _isSpeaking = false;
//     });
//   }

//   void _sendTypedQuery() {
//     String textPrompt = _textController.text.trim();
//     if (textPrompt.isNotEmpty) {
//       _textController.clear();
//       setState(() {
//         _spokenText = textPrompt;
//         _responseText = "";
//       });
//       _fetchChatbotResponse(textPrompt);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F2027),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           "🧠 UGPT Voice Assistant",
//           style: GoogleFonts.poppins(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.cyanAccent,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   ..._conversation.map((message) => _buildChatBubble(
//                         message['text']!,
//                         message['role'] == 'user',
//                       ).animate().fadeIn(duration: 400.ms)),
//                   if (_isLoadingResponse)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         child: CircularProgressIndicator(
//                           color: Colors.cyanAccent,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             _buildInputSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChatBubble(String text, bool isUser) {
//     return GestureDetector(
//       onLongPress: () {
//         Clipboard.setData(ClipboardData(text: text));
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Copied to clipboard'),
//             duration: Duration(seconds: 1),
//           ),
//         );
//       },
//       child: Align(
//         alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isUser
//                 ? Colors.cyanAccent.withOpacity(0.2)
//                 : Colors.white.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isUser ? Colors.cyanAccent : Colors.greenAccent,
//               width: 1,
//             ),
//           ),
//           child: Text(
//             text,
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               color: isUser ? Colors.white : Colors.greenAccent,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1F1F2D),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(26),
//           topRight: Radius.circular(26),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black45,
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _textController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white12,
//                     hintText: 'Ask me anything about ...',
//                     hintStyle: const TextStyle(color: Colors.white54),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 14,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               GestureDetector(
//                 onTap: _isLoadingResponse ? null : _sendTypedQuery,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.cyanAccent,
//                   child: const Icon(Icons.send, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: _isListening ? _stopListening : _startListening,
//                 child: CircleAvatar(
//                   radius: 30,
//                   backgroundColor: _isListening ? Colors.red : Colors.cyan,
//                   child: Icon(
//                     _isListening ? Icons.stop : Icons.mic,
//                     size: 30,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 30),
//               if (_isSpeaking)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.volume_off,
//                     color: Colors.redAccent,
//                     size: 36,
//                   ),
//                   onPressed: _stopSpeaking,
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
