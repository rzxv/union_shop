import 'package:flutter/foundation.dart';
import 'package:union_shop/models/orders.dart';

/// Very small user model used for demo account UI.
class User {
  final String email;
  final String? firstName;
  final String? lastName;

  const User({required this.email, this.firstName, this.lastName});

  User copyWith({String? firstName, String? lastName}) => User(email: email, firstName: firstName ?? this.firstName, lastName: lastName ?? this.lastName);
}

/// Very small in-memory auth helper used for UI wiring in this demo app.
///
/// This intentionally keeps behaviour simple: a global [ValueNotifier]
/// indicates whether a user is signed in. Callers can listen and react.
class AuthModel {
  // Current user (null when signed out).
  static final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

  // Convenience boolean notifier for backwards compatibility with UI that listens to sign-in state.
  static final ValueNotifier<bool> isSignedIn = ValueNotifier<bool>(false);

  // Simulate signing in (sets state to signed in). Provide email to associate the session.
  static void signIn({required String email}) {
    currentUser.value = User(email: email);
    isSignedIn.value = true;
  }

  // Simulate signing up (also sets state to signed in).
  static void signUp({required String email}) {
    currentUser.value = User(email: email);
    isSignedIn.value = true;
  }

  // Update profile fields for the current user.
  static void updateProfile({String? firstName, String? lastName}) {
    final existing = currentUser.value;
    if (existing == null) return;
    currentUser.value = existing.copyWith(firstName: firstName, lastName: lastName);
  }

  // Sign the user out and clear any session-scoped data (demo: clear orders).
  static void signOut() {
    currentUser.value = null;
    isSignedIn.value = false;
    // Clear demo order history on sign out so account page refreshes to empty state.
    globalOrders.clear();
  }
}
