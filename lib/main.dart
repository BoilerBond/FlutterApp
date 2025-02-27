import "package:datingapp/presentation/screens/main%20navigation/main_nav.dart";
import "package:flutter/material.dart";


void main() {
 runApp(const MyApp());
}


class MyApp extends StatelessWidget {
 const MyApp({super.key});


 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: "Boiler Bond",
     theme: ThemeData(
       // This is the theme of your application.
       //
       // TRY THIS: Try running your application with "flutter run". You"ll see
       // the application has a purple toolbar. Then, without quitting the app,
       // try changing the seedColor in the colorScheme below to Colors.green
       // and then invoke "hot reload" (save your changes or press the "hot
       // reload" button in a Flutter-supported IDE, or press "r" if you used
       // the command line to start the app).
       //
       // Notice that the counter didn"t reset back to zero; the application
       // state is not lost during the reload. To reset the state, use hot
       // restart instead.
       //
       // This works for code too, not just values: Most code changes can be
       // tested with just a hot reload.
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
       useMaterial3: true,
     ),
     home: MyHomePage(title: "Flutter Demo Home Page"),
   );
 }
}


class MyHomePage extends StatelessWidget {
 final String title;
 const MyHomePage({super.key, required this.title});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Welcome to Boiler Bond"),
       backgroundColor: Theme.of(context).colorScheme.primary,
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           ElevatedButton(
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const LoginPage()),
               );
             },
             child: const Text("Login"),
           ),
           const SizedBox(height: 30),
           ElevatedButton(
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const RegisterPage()),
               );
             },
             child: const Text("Register"),
           ),
           const SizedBox(height: 30),
           ElevatedButton(
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const AboutPage()),
               );
             },
             child: const Text("About Boiler Bond"),
           ),
           const SizedBox(height: 30),
           ElevatedButton(
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const MainNavigation()),
               );
             },
             child: const Text("Debug"),
           ),
         ],
       ),
     ),
   );
 }
}


class LoginPage extends StatelessWidget {
 const LoginPage({super.key});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Login"),
     ),
     body: const Center(
       child: Text("Login page"),
     ),
   );
 }
}


class RegisterPage extends StatelessWidget {
 const RegisterPage({super.key});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Register"),
     ),
     body: const Center(
       child: Text("Register page"),
     ),
   );
 }
}


class AboutPage extends StatelessWidget {
 const AboutPage({super.key});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("About LoveConnect"),
     ),
     body: const Center(
       child: Padding(
         padding: EdgeInsets.all(10.0),
         child: Text(
           "Add about text here",
           textAlign: TextAlign.center,
         ),
       ),
     ),
   );
 }
}

