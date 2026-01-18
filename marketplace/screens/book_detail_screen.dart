import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 400, // Increased height for better visibility
              width: double.infinity,
              color: Colors.black12, // Grey background for contrast
              child: InteractiveViewer(
                // Allows users to pinch-to-zoom and see the full uncropped image
                child: Image.network(
                  book.imageUrl, 
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, _, __) => Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RM ${book.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                      Chip(label: Text(book.condition), backgroundColor: Colors.blue[100]),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(book.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('by ${book.author}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 20),
                  Text('Category: ${book.category}', style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height: 20),
                  Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // Shows the actual description entered by the user
                  Text(book.description.isNotEmpty ? book.description : 'No description provided.'),
                  SizedBox(height: 30),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.favorite_border),
                          label: Text('Wishlist'),
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Wishlist')));
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.chat),
                          label: Text('Chat Seller'),
                          onPressed: () {
                            // Chat logic here
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}