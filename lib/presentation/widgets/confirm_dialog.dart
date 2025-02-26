import 'package:flutter/material.dart';

Future<bool> confirmDialog(BuildContext context, Function() onConfirm) async {
  bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: EdgeInsets.all(16.0),
        contentPadding: EdgeInsets.all(16.0),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context, true);
                },
              )
            ],
          ),
        ],
      );
    },
  );

  return result ?? false;
}
