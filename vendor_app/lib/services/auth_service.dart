import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // GET UID
  userID() => _auth.currentUser?.uid;

  // GET CurrentUser
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

  bool? isAnonymous() => _auth.currentUser?.isAnonymous;

  isAuthenticated() {
    if (_auth.currentUser != null && isAnonymous() == false) {
      return true;
    }
    return false;
  }

  // create user obj based on firebase user
  UserModel? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return UserModel();
  }

  // auth change user stream
  Stream<UserModel?>? get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // sign in Anonymously
  Future<auth.User?> getOrCreateUser() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
    return _auth.currentUser;
  }

  // sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  // register with email and password
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _userFromFirebase(credential.user);
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
