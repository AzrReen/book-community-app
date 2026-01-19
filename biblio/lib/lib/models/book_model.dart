import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final String category;
  final String condition;
  final String imageUrl;
  final String sellerId;
  final Timestamp createdAt;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.category,
    required this.condition,
    required this.imageUrl,
    required this.sellerId,
    required this.createdAt,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'price': price,
      'category': category,
      'condition': condition,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'createdAt': createdAt,
      'description': description,
    };
  }

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? 'Other',
      condition: data['condition'] ?? 'Used',
      imageUrl: data['imageUrl'] ?? '',
      sellerId: data['sellerId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      description: data['description'] ?? '',
    );
  }
}