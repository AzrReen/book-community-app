import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required dynamic imageFile, // Can be File or Uint8List for web
  }) async {
    try {
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('profile_images/$userId/$fileName');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For web, imageFile should be Uint8List
        uploadTask = ref.putData(
          imageFile as Uint8List,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        // For mobile, imageFile should be File
        uploadTask = ref.putFile(
          imageFile as File,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Delete profile image
  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}