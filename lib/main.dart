import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'color_schemes.g.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: lightColorScheme),
      darkTheme: ThemeData(colorScheme: darkColorScheme),
      home: const Home(),
      themeMode: ThemeMode.dark,
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Collect Recyclables and Earn Rewards",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Text(
                  "Are you a ...?",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 1, label: "User"),
                    DropdownMenuEntry(value: 2, label: "Agent"),
                    DropdownMenuEntry(value: 3, label: "Buyer"),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Get Started"),
                ),
                // Spacer(flex: 1),
                Image.asset(
                  "assets/plant.png",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
