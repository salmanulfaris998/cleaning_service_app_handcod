import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'google_auth_service.dart';
import '../models/user_model.dart';

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
        return UserModel.fromFirebaseUser(userCredential!.user!);
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
}