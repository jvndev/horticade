import 'package:horticade/models/entity.dart';
import 'package:horticade/models/location.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseService _db = DatabaseService();

  static String pretifyAuthErrorCode(String message) {
    return message
        .split('-')
        .map((e) => e.replaceRange(0, 1, e[0].toUpperCase()))
        .fold('', (str, e) => '$str $e')
        .trimLeft();
  }

  static Future<String?> login(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: password)
          .timeout(awaitTimeout);

      return null;
    } on FirebaseAuthException catch (e) {
      return pretifyAuthErrorCode(e.code);
    } catch (e) {
      return "Unable to log in";
    }
  }

  static Future<void> logout() async {
    _auth.signOut();
  }

  static Future<String?> register(
    String name,
    Location location,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(awaitTimeout);
      await _db.createEntity(Entity(
          uid: userCredential.user!.uid, name: name, location: location));

      return null;
    } on FirebaseAuthException catch (e) {
      return pretifyAuthErrorCode(e.code);
    } catch (e) {
      return "Failed to register";
    }
  }

  static AuthUser? _convertFirebaseUser(User? user) =>
      user != null ? AuthUser(uid: user.uid, email: user.email ?? '') : null;

  static Stream<AuthUser?> get userStream =>
      _auth.authStateChanges().map((user) => _convertFirebaseUser(user));

  static AuthUser? get user => _convertFirebaseUser(_auth.currentUser);
}
