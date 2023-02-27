import 'package:fb_chat_app/Utils/source.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Login Services
  Future loginEmailPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Register Services
  Future registerEmailPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      await DatabaseServices(uid: user.uid).savingUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Log Out Services
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedIn(false);
      await HelperFunctions.saveUserName("");
      await HelperFunctions.saveUserEmail("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
