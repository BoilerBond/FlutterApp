import 'package:cloud_functions/cloud_functions.dart';
import 'package:datingapp/presentation/widgets/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DangerZone extends StatefulWidget {
  const DangerZone({super.key});

  @override
  State<DangerZone> createState() => _DangerZoneState();
}

class _DangerZoneState extends State<DangerZone> {
  String errorMessage = "";

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
          Text(errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error),),
        ],
      ),
    );
  }


  void _onDeleteAccountPress(BuildContext context) {
    confirmDialog(context, () async {
      // TODO: delete user information in Firebase
      final callable = FirebaseFunctions.instance.httpsCallable('user-account-deleteAccountProfile');
      final Map<String, dynamic> result = Map<String, dynamic>.from((await callable.call()).data);

      if (result.containsKey("error")) {
        setState(() {
          errorMessage = result["error"];
        });
        return;
      }

      // get current user
      final user = FirebaseAuth.instance.currentUser;
      try {
        // requires user data to be stored in paths with their uid
        await user?.delete();
      }
      on FirebaseAuthException {
        // user signed-in too long ago
        // log them out so they sign-in again
        await FirebaseAuth.instance.signOut();
      }
      await FirebaseAuth.instance.signOut();
    });
  }
}
