import 'package:flutter/material.dart';

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  // 🎨 Palette - Adapted to your Earth Tone Theme
  final Color colorBark = const Color(0xFF41302C);
  final Color colorFjord = const Color(0xFF54737D);
  final Color colorOatLight = const Color(0xFFEBE2D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBark, // ✅ Matches Marketplace/Profile
        title: const Text("Upcoming Events", style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Removes back button on main tabs
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Event 1
          _buildEventCard(
            context,
            title: "Book Launch – In Safe Hands",
            time: "02:00 PM – 04:00 PM",
            location: "MPH TRX",
            imagePath: 'assets/images/event1.jpg',
          ),
          const SizedBox(height: 16),
          // Event 2
          _buildEventCard(
            context,
            title: "The Dance Of Life by Dr. Wong Keh Shin",
            time: "02:00 PM – 04:00 PM",
            location: "MPH TRX",
            imagePath: 'assets/images/event2.jpg', 
          ),
        ],
      ),
    );
  }

Widget _buildEventCard(BuildContext context, {required String title, required String time, required String location, required String imagePath}) {
    return GestureDetector(
      onTap: () => _showEventPopup(context, title, time, location),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ UPDATED: Displays the actual image now
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath, // ✅ Uses the path you pass in
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorBark)),
                  const SizedBox(height: 8),
                  _buildIconText(Icons.access_time, time),
                  const SizedBox(height: 4),
                  _buildIconText(Icons.location_on, location),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  // THE POPUP FUNCTION
  void _showEventPopup(BuildContext context, String title, String time, String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title, style: TextStyle(color: colorBark, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Would you like to register for this event?"),
              const SizedBox(height: 15),
              _buildIconText(Icons.calendar_today, "Save to Calendar"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colorFjord), // ✅ Uses your Fjord color
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Registered Successfully!")),
                );
              },
              child: const Text("Register", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}