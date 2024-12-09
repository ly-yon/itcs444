import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _role;
  // bool _isLoading = true;

  User? get user => _user;
  String? get role => _role;
  // bool get isLoading => _isLoading;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _user = firebaseUser;
      if (_user != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .get();
          _role = doc['role']; // Assumes Firestore has a 'role' field
        } catch (e) {
          _role = null;
          debugPrint("Error fetching role: $e");
        }
      } else {
        _role = null;
      }
      // _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _fetchUserRole() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      _role = doc['role']; // Assumes Firestore has a 'role' field
    } catch (e) {
      _role = null;
      debugPrint("Error fetching role: $e");
    }
  }

  Future<void> login(String email, String password) async {
    // _isLoading = true;
    // notifyListeners();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      await _fetchUserRole();
    } on FirebaseAuthException catch (e) {
      print("Error in signIn: ${e.message}");
    }
    // _isLoading = false;
    notifyListeners();
  }

  Future<void> signUp(
      String email, String password, String name, String role) async {
    // _isLoading = true;
    // notifyListeners();

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user?.uid,
        'name': name,
        'email': email,
        'role': role, // e.g., Admin or Student
      });
      _user = credential.user;
      await _fetchUserRole();
      // _isLoading = false;
    } on FirebaseAuthException catch (e) {
      print("Error in createUser: ${e.message}");
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _role = null;
    notifyListeners();
  }
}
