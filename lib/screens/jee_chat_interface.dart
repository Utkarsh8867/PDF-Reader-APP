// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/chatbot_api_service.dart';
// import '../services/history_storage.dart';

// class JEEChatInterface extends StatefulWidget {
//   final String? initialPrompt;

//   const JEEChatInterface({super.key, this.initialPrompt});

//   @override
//   State<JEEChatInterface> createState() => _JEEChatInterfaceState();
// }

// class _JEEChatInterfaceState extends State<JEEChatInterface> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, dynamic>> _chatHistory = []; // Supports text & images
//   final ChatbotApiService _chatbotService = ChatbotApiService();
//   bool _isLoading = false;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
//       _sendMessage(widget.initialPrompt!);
//     }
//   }

//   Future<void> _sendMessage([String? presetMessage, File? image]) async {
//     final message = presetMessage ?? _controller.text.trim();
//     if (message.isEmpty && image == null || _isLoading) return;

//     setState(() {
//       _chatHistory.add({"role": "user", "message": message, "image": image});
//       _controller.clear();
//       _isLoading = true;
//     });

//     await HistoryStorage().addPrompt(message);

//     try {
//       final response = await _chatbotService.fetchJEEAnswer(message);
//       setState(() {
//         _chatHistory.add({"role": "bot", "message": response});
//       });
//     } catch (e) {
//       setState(() {
//         _chatHistory.add({
//           "role": "bot",
//           "message":
//               "⚠️ Failed to fetch response.\nPlease check your internet connection.",
//         });
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       File image = File(pickedFile.path);
//       _sendMessage("Uploaded an image:", image);
//     }
//   }

//   Future<void> _captureImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       File image = File(pickedFile.path);
//       _sendMessage("Captured an image:", image);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "UGPT Chat",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Expanded(
//             child:
//                 _chatHistory.isEmpty
//                     ? _buildEmptyState()
//                     : AnimationLimiter(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 12,
//                         ),
//                         itemCount: _chatHistory.length,
//                         itemBuilder: (context, index) {
//                           final chat = _chatHistory[index];
//                           final isUser = chat['role'] == 'user';
//                           return AnimationConfiguration.staggeredList(
//                             position: index,
//                             duration: const Duration(milliseconds: 500),
//                             child: SlideAnimation(
//                               horizontalOffset: isUser ? 100.0 : -100.0,
//                               child: FadeInAnimation(
//                                 child: _buildChatBubble(chat),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//           ),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: CircularProgressIndicator(color: Colors.blue),
//             ),
//           _buildInputField(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 72),
//           const SizedBox(height: 12),
//           Text(
//             "Start a conversation with UGPT!",
//             style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             "Ask any questions.",
//             style: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatBubble(Map<String, dynamic> chat) {
//     bool isUser = chat['role'] == 'user';
//     String? message = chat['message'];
//     File? image = chat['image'];

//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blue : Colors.grey[850],
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft:
//                 isUser ? const Radius.circular(16) : const Radius.circular(4),
//             bottomRight:
//                 isUser ? const Radius.circular(4) : const Radius.circular(16),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 4,
//               offset: const Offset(2, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (message != null)
//               Text(
//                 message,
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 16,
//                   height: 1.5,
//                 ),
//               ),
//             if (image != null) ...[
//               const SizedBox(height: 8),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.file(
//                   image,
//                   height: 200,
//                   width: 200,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField() {
//     return Container(
//       color: Colors.black,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.image, color: Colors.white),
//             onPressed: _pickImage,
//           ),
//           IconButton(
//             icon: const Icon(Icons.camera_alt, color: Colors.white),
//             onPressed: _captureImage,
//           ),
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
//               decoration: InputDecoration(
//                 hintText: 'Ask to UGPT...',
//                 hintStyle: GoogleFonts.poppins(
//                   color: Colors.white54,
//                   fontSize: 14,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[900],
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(28),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           InkWell(
//             onTap: () => _sendMessage(),
//             borderRadius: BorderRadius.circular(28),
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.blue,
//               ),
//               child: const Icon(Icons.send, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/chatbot_api_service.dart';
import '../services/history_storage.dart';

class JEEChatInterface extends StatefulWidget {
  final String? initialPrompt;
  const JEEChatInterface({super.key, this.initialPrompt});

  @override
  State<JEEChatInterface> createState() => _JEEChatInterfaceState();
}

class _JEEChatInterfaceState extends State<JEEChatInterface> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatHistory = [];
  final ChatbotApiService _chatbotService = ChatbotApiService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt?.isNotEmpty ?? false) {
      _sendMessage(widget.initialPrompt!);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage([String? presetMessage, File? image]) async {
    final message = presetMessage ?? _controller.text.trim();
    if ((message.isEmpty && image == null) || _isLoading) return;

    setState(() {
      _chatHistory.add({
        "role": "user",
        "message": message,
        "image": image,
        "timestamp": DateTime.now(),
      });
      _controller.clear();
      _isLoading = true;
    });

    _scrollToBottom();
    await HistoryStorage().addPrompt(message);

    try {
      final response = await _chatbotService.fetchJEEAnswer(message);
      setState(() {
        _chatHistory.add({
          "role": "bot",
          "message": response,
          "timestamp": DateTime.now(),
        });
      });
    } catch (_) {
      setState(() {
        _chatHistory.add({
          "role": "bot",
          "message":
              "⚠️ Failed to fetch response. Please check your internet connection.",
          "timestamp": DateTime.now(),
        });
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _sendMessage("Uploaded an image:", File(file.path));
    }
  }

  Future<void> _captureImage() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      _sendMessage("Captured an image:", File(file.path));
    }
  }

  Widget _buildChatBubble(Map<String, dynamic> chat) {
    final isUser = chat['role'] == 'user';
    final timestamp = chat['timestamp'] as DateTime?;
    final time = timestamp != null ? DateFormat.Hm().format(timestamp) : '';
    final File? image = chat['image'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.smart_toy, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chat['message'] != null)
                    Text(
                      chat['message'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  if (image != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        image,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                      ),
                      if (!isUser)
                        IconButton(
                          onPressed: () => _copyText(chat['message']),
                          icon: const Icon(
                            Icons.copy,
                            size: 18,
                            color: Colors.white38,
                          ),
                          tooltip: "Copy",
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Colors.white12,
              child: Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  Widget _buildShimmerBubble() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 2)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _captureImage,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                hintStyle: GoogleFonts.poppins(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white24,
            size: 72,
          ),
          const SizedBox(height: 12),
          Text(
            "Ask anything to UGPT!",
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "UGPT Chat",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: "View GitHub",
            onPressed:
                () => launchUrl(Uri.parse("https://github.com/Utkarsh8867")),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _chatHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      itemCount: _chatHistory.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isLoading && index == _chatHistory.length) {
                          return _buildShimmerBubble();
                        }
                        final chat = _chatHistory[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildChatBubble(chat),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }
}
