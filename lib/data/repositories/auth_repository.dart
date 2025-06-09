import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<UserModel?> getCurrentUserProfile() async {
    if (currentUser == null) return null;
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', currentUser!.id)
          .single();
      return UserModel.fromMap(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<AuthResponse> signUp(String email, String password, {String? fullName, String? userRole}) async {
  try {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null) 'full_name': fullName,
        if (userRole != null) 'role': userRole,
      },
    );

    // 'users' tablosuna manuel ekleme
    if (response.user != null) {
      await _client.from('users').upsert({
        'id': response.user!.id,
        'email': email,
        if (fullName != null) 'full_name': fullName,
        if (userRole != null) 'role': userRole,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }

    return response;
  } catch (e) {
    print('Sign up error: $e');
    rethrow;
  }
}


  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile({String? fullName, String? avatarUrl}) async {
    if (currentUser == null) throw Exception('User not logged in');
    try {
      final updates = <String, dynamic>{
        'id': currentUser!.id,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _client.from('users').upsert(updates);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}