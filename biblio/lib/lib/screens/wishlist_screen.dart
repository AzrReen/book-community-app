import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../services/marketplace_service.dart';
import '../providers/auth_provider.dart';
import '/marketplace/screens/book_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  final MarketplaceService _service = MarketplaceService();
  final Color colorBark = const Color(0xFF41302C);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;

    if (user == null) return const Scaffold(body: Center(child: Text("Please login first")));

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: StreamBuilder<List<Book>>(
        stream: _service.getWishlist(user.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
            return Center(child: CircularProgressIndicator(color: colorBark));
          
          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return Center(child: Text('Your wishlist is empty.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                child: ListTile(
                  leading: Image.network(book.imageUrl, width: 50, fit: BoxFit.cover),
                  title: Text(book.title),
                  subtitle: Text('RM ${book.price.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
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