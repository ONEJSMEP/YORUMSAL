import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth; // Alias to avoid conflict
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  UserModel? _userProfile;
  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;

  AuthProvider(supabase_auth.SupabaseClient client) : _authRepository = AuthRepository(client) {
    _authRepository.authStateChanges.listen(_onAuthStateChanged);
    _checkInitialAuthStatus();
  }

  UserModel? get userProfile => _userProfile;
  supabase_auth.User? get currentUser => _authRepository.currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> _checkInitialAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();
    if (_authRepository.currentUser != null) {
      await _loadUserProfile(_authRepository.currentUser!.id);
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(supabase_auth.AuthState state) async {
    _status = AuthStatus.loading;
    notifyListeners();
    final session = state.session;
    if (session != null) {
      await _loadUserProfile(session.user.id);
      _status = AuthStatus.authenticated;
    } else {
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
    }
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      _userProfile = await _authRepository.getCurrentUserProfile();
    } catch (e) {
      print("Error loading user profile in provider: $e");
      _userProfile = null; // Ensure profile is null on error
    }
  }

  Future<bool> signUp(String email, String password, {String? fullName, required String userRole}) async {
  _status = AuthStatus.loading;
  _errorMessage = null;
  notifyListeners();
  try {
    await _authRepository.signUp(
      email,
      password,
      fullName: fullName,
      userRole: userRole,
    );
    return true;
  } on supabase_auth.AuthException catch (e) {
    _errorMessage = e.message;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  } catch (e) {
    _errorMessage = 'Beklenmedik bir hata oluştu: $e';
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }
}


  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authRepository.signIn(email, password);
      // AuthStateChanges listener will handle setting status to authenticated
      return true;
    } on supabase_auth.AuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Beklenmedik bir hata oluştu: $e';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      await _authRepository.signOut();
      // AuthStateChanges listener will handle setting status to unauthenticated
    } catch (e) {
      _errorMessage = 'Çıkış yaparken hata: $e';
      // Durumu koru veya hata durumuna geçir
      _status = AuthStatus.authenticated; // veya AuthStatus.error
      notifyListeners();
    }
  }
  
  Future<void> updateUserProfile({String? fullName, String? avatarUrl}) async {
    if (currentUser == null) return;
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      await _authRepository.updateUserProfile(fullName: fullName, avatarUrl: avatarUrl);
      await _loadUserProfile(currentUser!.id); // Profili yeniden yükle
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Profil güncellenirken hata: $e';
      _status = AuthStatus.authenticated; // Hata olsa bile oturum açık kalabilir
      notifyListeners();
    }
  }
}