import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInManager {
  final Function(String email, String name, String photoUrl, String idToken) onSuccess;
  final Function(String) onFailure;

  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(
    scopes: ['email', 'profile'],
    // clientId is only needed for Flutter Web
  );

  GoogleSignInManager({required this.onSuccess, required this.onFailure});

  Future<void> signIn() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final auth = await account.authentication;
        final idToken = auth.idToken ?? "";

        onSuccess(
          account.email,
          account.displayName ?? "",
          account.photoUrl ?? "",
          idToken,
        );
      } else {
        onFailure("Sign-in cancelled by user");
      }
    } catch (e) {
      onFailure("Google Sign-in failed: $e");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
