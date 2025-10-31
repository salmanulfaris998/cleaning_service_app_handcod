import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_lib;
import 'package:firebase_auth/firebase_auth.dart';

import 'google_auth_service.dart';
import '../models/user_model.dart';

/// Global Supabase client instance
final supabase = supabase_lib.Supabase.instance.client;

// Provider for GoogleAuthService
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final googleAuthService = ref.read(googleAuthServiceProvider);
  return AuthRepository(googleAuthService);
});

class AuthRepository {
  final GoogleAuthService _googleAuthService;

  AuthRepository(this._googleAuthService);

  // Get current user
  UserModel? get currentUser {
    final firebaseUser = _googleAuthService.currentUser;
    return firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null;
  }

  // Auth state changes stream
  Stream<UserModel?> get authStateChanges {
    return _googleAuthService.authStateChanges.map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final userCredential = await _googleAuthService.signInWithGoogle();
      if (userCredential?.user != null) {
        final firebaseUser = userCredential!.user!;
        
        // Sync user data to Supabase
        await syncUserWithSupabase(firebaseUser);
        
        return UserModel.fromFirebaseUser(firebaseUser);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleAuthService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      await _googleAuthService.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _googleAuthService.isSignedIn;

  // Get user display name
  String? get userDisplayName => _googleAuthService.userDisplayName;

  // Get user email
  String? get userEmail => _googleAuthService.userEmail;

  // Get user photo URL
  String? get userPhotoURL => _googleAuthService.userPhotoURL;

  /// Sync the Firebase user with Supabase database
  Future<void> syncUserWithSupabase(User firebaseUser) async {
    try {
      final data = {
        'firebase_uid': firebaseUser.uid,
        'name': firebaseUser.displayName,
        'email': firebaseUser.email,
        'phone': firebaseUser.phoneNumber,
        'photo_url': firebaseUser.photoURL,
      };

      await supabase.from('users').upsert(
        data,
        onConflict: 'firebase_uid',
      );

      print('✅ User synced successfully to Supabase.');
    } catch (e) {
      print('❌ Error syncing user to Supabase: $e');
    }
  }
}