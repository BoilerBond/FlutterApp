import 'package:cloud_functions/cloud_functions.dart';
import 'package:datingapp/presentation/widgets/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DangerZone extends StatefulWidget {
  const DangerZone({super.key});

  @override
  State<DangerZone> createState() => _DangerZoneState();
}

class _DangerZoneState extends State<DangerZone> {
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danger Zone')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _onDeleteAccountPress(context),
                child: Text(
                  'Delete Account',
                ),
              ),
            ),
          ),
          Text(
            _errorMessage,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }


  void _onDeleteAccountPress(BuildContext context) {
    confirmDialog(context, () async {
      final user = FirebaseAuth.instance.currentUser;
      try {
        final callable = FirebaseFunctions.instance.httpsCallable('user-account-deleteAccountProfile');
        await callable.call();
        await user?.delete();
      } on FirebaseAuthException {
        // user signed-in too long ago
        // need to reauthenticate
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user!.reauthenticateWithCredential(credential);
        await user.delete();
      }

      await FirebaseAuth.instance.signOut();
    });
  }
}
