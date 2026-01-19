import 'package:flutter/material.dart';

// 1. The List of Chats
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  // 🎨 Palette
  final Color colorBark = const Color(0xFF41302C);
  final Color colorOatLight = const Color(0xFFEBE2D9); 
  final Color colorSienna = const Color(0xFF854D49);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBark,
        title: const Text("Messages", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit_note, color: Colors.white))],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search chats...",
                prefixIcon: Icon(Icons.search, color: colorBark),
                filled: true,
                fillColor: colorOatLight, 
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          // Chat List
          Expanded(
            child: ListView(
              children: [
                _buildChatTile(context, "BibloiphibeBetty", "Loved your review...", "2m ago", true),
                _buildChatTile(context, "ReokishBob", "Do you have the physical copy...", "1h ago", false),
                _buildChatTile(context, "ReokishRita", "Sent a photo", "Yesterday", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, String name, String message, String time, bool isUnread) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.grey[300], radius: 25, child: const Icon(Icons.person, color: Colors.white)),
      title: Text(name, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (isUnread) 
             Padding(padding: const EdgeInsets.only(top: 4), child: CircleAvatar(radius: 4, backgroundColor: colorSienna)),
        ],
      ),
      onTap: () {
        // ✅ Navigate to the specific Chat Room
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(userName: name)),
        );
      },
    );
  }
}

// 2. The Individual Chat Room
class ChatPage extends StatefulWidget {
  final String userName;
  const ChatPage({super.key, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final Color colorBark = const Color(0xFF41302C);
  final Color colorFjord = const Color(0xFF54737D);
  
  // Dummy messages data
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hey! How are you?", "isSent": false, "timestamp": "10:30 AM"},
    {"text": "I'm doing great! Just finished reading", "isSent": true, "timestamp": "10:31 AM"},
    {"text": "Loved your review on The Midnight Library!", "isSent": false, "timestamp": "10:32 AM"},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "text": _messageController.text,
          "isSent": true,
          "timestamp": "now",
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.userName, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: message["isSent"] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: message["isSent"] ? colorFjord : Colors.grey[300], // ✅ User Fjord for sent
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: message["isSent"] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message["text"],
                            style: TextStyle(fontSize: 15, color: message["isSent"] ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message["timestamp"],
                            style: TextStyle(fontSize: 11, color: message["isSent"] ? Colors.white70 : Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline, color: colorFjord)),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(onPressed: _sendMessage, icon: Icon(Icons.send, color: colorFjord)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}