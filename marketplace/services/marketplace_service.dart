import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class MarketplaceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // ImgBB API Key
  final String _imgBBApiKey = 'bc0dfb7ce87b8773c1562fc25774582a';

  Future<String> uploadToImgBB(XFile imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$_imgBBApiKey'),
      );

      // Read image as bytes for cross-platform compatibility
      var bytes = await imageFile.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.name,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['data']['url']; // Direct URL from ImgBB
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

      await _db.collection('books').add(bookData); // Metadata to Firestore
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  Stream<List<Book>> getBooks() {
    return _db.collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Book.fromFirestore(doc))
            .toList());
  }

  Future<void> updateBook(String bookId, Book book, XFile? newImageFile) async {
    try {
      Map<String, dynamic> updatedData = book.toMap();
      
      // If a new image was picked, upload it and update the URL
      if (newImageFile != null) {
        String newImageUrl = await uploadToImgBB(newImageFile);
        updatedData['imageUrl'] = newImageUrl;
      }

      await _db.collection('books').doc(bookId).update(updatedData);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }
}