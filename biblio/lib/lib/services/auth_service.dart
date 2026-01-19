import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email, password, AND username
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {
      // Check if username is taken
      final usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      if (usernameQuery.docs.isNotEmpty) throw Exception('Username already taken');

      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userModel = UserModel(
          userId: credential.user!.uid,
          username: username.toLowerCase(),
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(userModel.toMap());
        await credential.user!.updateDisplayName(name);
        return userModel;
      }
      return null;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // ✅ New: Sign in with Username
  Future<UserModel?> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      final usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      if (usernameQuery.docs.isEmpty) throw Exception('Username not found');

      final email = usernameQuery.docs.first.data()['email'] as String;

      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await getUserData(credential.user!.uid);
      }
      return null;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Sign in with Google (Fixed accessToken error)
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

        if (!userDoc.exists) {
          // Generate unique username
          String username = userCredential.user!.email!.split('@')[0];
          final userModel = UserModel(
            userId: userCredential.user!.uid,
            username: username,
            name: userCredential.user!.displayName ?? 'User',
            email: userCredential.user!.email ?? '',
            profileImageUrl: userCredential.user!.photoURL,
            createdAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
          return userModel;
        } else {
          return UserModel.fromDocument(userDoc);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) return UserModel.fromDocument(doc);
    return null;
  }

  Future<void> updateUserProfile({required String userId, String? name, String? bio, String? profileImageUrl}) async {
    final Map<String, dynamic> updates = {};
    if (name != null) updates['name'] = name;
    if (bio != null) updates['bio'] = bio;
    if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update(updates);
      if (name != null && currentUser != null) await currentUser!.updateDisplayName(name);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}