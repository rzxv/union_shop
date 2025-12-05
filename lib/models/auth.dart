import 'package:flutter/foundation.dart';

/// Very small in-memory auth helper used for UI wiring in this demo app.
///
/// This intentionally keeps behaviour simple: a global [ValueNotifier]
/// indicates whether a user is signed in. Callers can listen and react.
class AuthModel {
  // Whether a user is signed in. Default: not signed in.
  static final ValueNotifier<bool> isSignedIn = ValueNotifier<bool>(false);

  // Simulate signing in (sets state to signed in).
  static void signIn() {
    isSignedIn.value = true;
  }

  // Simulate signing up (also sets state to signed in).
  static void signUp() {
    isSignedIn.value = true;
  }

  // Sign the user out.
  static void signOut() {
    isSignedIn.value = false;
  }
}
