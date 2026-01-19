import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class MarketplaceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _imgBBApiKey = 'bc0dfb7ce87b8773c1562fc25774582a';

  // --- EXISTING METHODS ---

  Future<String> uploadToImgBB(XFile imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$_imgBBApiKey'),
      );
      var bytes = await imageFile.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes('image', bytes, filename: imageFile.name);
      request.files.add(multipartFile);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['data']['url'];
      } else {
        throw Exception('ImgBB Upload Failed: ${jsonResponse['error']['message']}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> addBook(Book book, XFile imageFile) async {
    try {
      String imageUrl = await uploadToImgBB(imageFile);
      Map<String, dynamic> bookData = book.toMap();
      bookData['imageUrl'] = imageUrl; 
      await _db.collection('books').add(bookData);
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  Stream<List<Book>> getBooks() {
    return _db.collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  Future<void> updateBook(String bookId, Book book, XFile? newImageFile) async {
    try {
      Map<String, dynamic> updatedData = book.toMap();
      if (newImageFile != null) {
        String newImageUrl = await uploadToImgBB(newImageFile);
        updatedData['imageUrl'] = newImageUrl;
      }
      await _db.collection('books').doc(bookId).update(updatedData);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  // --- ✅ NEW METHODS FOR LISTINGS & WISHLIST ---

  // 1. Get books sold by a specific user
  Stream<List<Book>> getListings(String userId) {
    return _db.collection('books')
        .where('sellerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  // 2. Toggle Wishlist (Add if not exists, Remove if exists)
  Future<bool> toggleWishlist(String userId, Book book) async {
    try {
      final docRef = _db.collection('users').doc(userId).collection('wishlist').doc(book.id);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();
        return false; // Removed
      } else {
        await docRef.set(book.toMap()); // Save book details for easy retrieval
        return true; // Added
      }
    } catch (e) {
      throw Exception('Failed to toggle wishlist: $e');
    }
  }

  // 3. Check if book is in wishlist
  Stream<bool> isBookInWishlist(String userId, String bookId) {
    return _db.collection('users').doc(userId).collection('wishlist').doc(bookId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // 4. Get User's Wishlist
  Stream<List<Book>> getWishlist(String userId) {
    return _db.collection('users').doc(userId).collection('wishlist')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }
}