import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/auth.dart';
import 'package:union_shop/models/orders.dart';

void main() {
  group('AuthModel', () {
    tearDown(() {
      // Ensure we reset global state between tests
      AuthModel.signOut();
    });

    test('signIn and signUp set currentUser and isSignedIn', () {
      AuthModel.signIn(email: 'a@example.com');
      expect(AuthModel.currentUser.value?.email, equals('a@example.com'));
      expect(AuthModel.isSignedIn.value, isTrue);

      // signOut then signUp
      AuthModel.signOut();
      AuthModel.signUp(email: 'b@example.com');
      expect(AuthModel.currentUser.value?.email, equals('b@example.com'));
      expect(AuthModel.isSignedIn.value, isTrue);
    });

    test('updateProfile updates firstName and lastName when signed in', () {
      AuthModel.signIn(email: 'c@example.com');
      AuthModel.updateProfile(firstName: 'First', lastName: 'Last');
      final u = AuthModel.currentUser.value;
      expect(u, isNotNull);
      expect(u?.firstName, equals('First'));
      expect(u?.lastName, equals('Last'));
    });

    test('signOut clears user, signedIn and global orders', () {
      // add an order to globalOrders
      globalOrders.add(Order(id: 'o', placedAt: DateTime.now(), items: []));
      expect(globalOrders.orders.isNotEmpty, isTrue);

      AuthModel.signIn(email: 'd@example.com');
      expect(AuthModel.isSignedIn.value, isTrue);

      AuthModel.signOut();
      expect(AuthModel.currentUser.value, isNull);
      expect(AuthModel.isSignedIn.value, isFalse);
      expect(globalOrders.orders.isEmpty, isTrue);
    });
  });
}
