import 'package:com_goodtakes/model/user/usr_profile.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthenticationState {
  User? user;
  UsrProfile? profile;
  bool initDone = false;
  bool isAutoLogin = true;

  final Locale locale = const Locale(localeZhKey);

  void signOut() {
    user = null;
    profile = null;
    FirebaseAuth.instance.signOut();
  }

  void signIn(User user, UsrProfile profile) {
    this.user = user;
    this.profile = profile;
    isAutoLogin = false;
  }

  void updateProfile(DatabaseEvent event) {
    profile = profile?.copyWith({event.snapshot.key: event.snapshot.value});
  }

  Future<String?> get idToken async {
    if (user == null) {
      return null;
    } else {
      final exp = ((await user!.getIdTokenResult()).expirationTime);
      final dt = DateTime.now().add(const Duration(seconds: 590));
      if (((exp?.isBefore(dt)) ?? true)) {
        await user!.reload();
      }
      return user!.getIdToken();
    }
  }

  AuthenticationState({required this.profile, required this.user});
}
