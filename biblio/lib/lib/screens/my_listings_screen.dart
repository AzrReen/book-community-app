import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../services/marketplace_service.dart';
import '../providers/auth_provider.dart';
import '/marketplace/screens/add_book_screen.dart';
import '/marketplace/screens/book_detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  final MarketplaceService _service = MarketplaceService();
  
  // 🎨 Colors
  final Color colorBark = const Color(0xFF41302C);
  final Color colorOatLight = const Color(0xFFEBE2D9); 
  final Color colorSilt = const Color(0xFF685C55);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;

    if (user == null) return const Scaffold(body: Center(child: Text("Please login first")));

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: StreamBuilder<List<Book>>(
        stream: _service.getListings(user.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
            return Center(child: CircularProgressIndicator(color: colorBark));
          if (snapshot.hasError) 
            return Center(child: Text('Error loading listings', style: TextStyle(color: colorSilt)));
          
          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 80, color: colorOatLight),
                  const SizedBox(height: 10),
                  Text('You haven\'t listed any books yet.', style: TextStyle(color: colorSilt)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.imageUrl, 
                      width: 60, height: 80, 
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => Container(width: 60, color: Colors.grey[200]),
                    ),
                  ),
                  title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold, color: colorBark)),
                  subtitle: Text('RM ${book.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: colorBark),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => AddBookScreen(bookToEdit: book))
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => BookDetailScreen(book: book))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}