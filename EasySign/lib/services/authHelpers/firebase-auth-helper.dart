import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth-exception-handler.dart';
import 'auth-status-enum.dart';

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;
  late AuthResultStatus _status;

  ///
  /// Helper Functions
  ///
  Future<AuthResultStatus> createAccount({email, pass}) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  String empId = '';
  Future<List> createEmployeAccount({email, pass}) async {
    FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);
    try {
      var authResult = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: email, password: pass);
      if (authResult.user != null) {
        empId = FirebaseAuth.instanceFor(app: app).currentUser!.uid;
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    await app.delete();
    return [
      _status,
        empId
    ];
  }

  Future<AuthResultStatus> login({email, pass}) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  logout() {
    _auth.signOut();
  }
}
