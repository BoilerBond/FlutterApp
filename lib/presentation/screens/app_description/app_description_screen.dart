import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppDescriptionScreen extends StatefulWidget {
  String navigatePath;
  AppDescriptionScreen({super.key, this.navigatePath = ""});

  @override
  _AppDescriptionScreenState createState() => _AppDescriptionScreenState();
}

class _AppDescriptionScreenState extends State<AppDescriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [Text("App description", style: Theme.of(context).textTheme.headlineLarge)],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: const Text('I read app description'),
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    String pathFromArguments = ModalRoute.of(context)?.settings.arguments as String? ?? "";
                    String finalNavigatePath = widget.navigatePath.isNotEmpty ? widget.navigatePath : pathFromArguments;

                    if (finalNavigatePath.isNotEmpty) {
                      Navigator.pushReplacementNamed(context, finalNavigatePath);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
