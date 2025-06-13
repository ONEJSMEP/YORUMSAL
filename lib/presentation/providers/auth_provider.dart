import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  UserModel? _userProfile;
  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;

  AuthProvider(this.firebaseAuth) {
    _checkInitialAuthStatus();
    // Firebase'de authStateChanges ile otomatik dinleme yapılabilir.
    firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  UserModel? get userProfile => _userProfile;
  User? get currentUser => firebaseAuth.currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // İlk açılışta kullanıcı oturumu kontrolü
  Future<void> _checkInitialAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();
    if (firebaseAuth.currentUser != null) {
      await loadUserProfile();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Firebase'de authState değişince otomatik tetiklenir
  Future<void> _onAuthStateChanged(User? user) async {
    _status = AuthStatus.loading;
    notifyListeners();
    if (user != null) {
      await loadUserProfile();
      _status = AuthStatus.authenticated;
    } else {
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
    }
    _errorMessage = null;
    notifyListeners();
  }

  // Kullanıcı profilini yükleme
  Future<void> loadUserProfile() async {
    if (firebaseAuth.currentUser != null) {
      // İstersen Firestore'dan daha fazla profil bilgisi çekebilirsin.
      _userProfile = UserModel(
        id: firebaseAuth.currentUser!.uid,
        email: firebaseAuth.currentUser!.email ?? '',
        fullName: firebaseAuth.currentUser!.displayName,
        avatarUrl: firebaseAuth.currentUser!.photoURL,
        role: "user", // Şimdilik "user"
        createdAt: DateTime.now(), // Şimdilik şimdi
        updatedAt: null,
      );
    } else {
      _userProfile = null;
    }
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, {String? fullName, required String userRole}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      // FirebaseAuth'ta isim eklemek için updateDisplayName kullanabilirsin
      if (fullName != null && firebaseAuth.currentUser != null) {
        await firebaseAuth.currentUser!.updateDisplayName(fullName);
      }
      await loadUserProfile();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
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
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await loadUserProfile();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
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
      await firebaseAuth.signOut();
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Çıkış yaparken hata: $e';
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({String? fullName, String? avatarUrl}) async {
    if (firebaseAuth.currentUser == null) return;
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      if (fullName != null) {
        await firebaseAuth.currentUser!.updateDisplayName(fullName);
      }
      if (avatarUrl != null) {
        await firebaseAuth.currentUser!.updatePhotoURL(avatarUrl);
      }
      await loadUserProfile();
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Profil güncellenirken hata: $e';
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }
}
// AuthProvider, FirebaseAuth ile kullanıcı oturumlarını yönetir.
// Kullanıcı kaydı, girişi, çıkışı ve profil güncelleme işlemlerini içerir.