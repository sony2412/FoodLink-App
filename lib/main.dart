import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';

void main() async {
  try {
    // 1. Ensure Widgets are initialized
    WidgetsFlutterBinding.ensureInitialized();
    
    // 2. Initialize Local Storage
    await GetStorage.init();

    // 3. Initialize Firebase with Error Handling
    debugPrint("Initializing Firebase...");
    await Firebase.initializeApp();
    debugPrint("Firebase Initialized Successfully");

    runApp(const FoodLink());
  } catch (e) {
    debugPrint("CRITICAL ERROR DURING STARTUP: $e");
    // Show a basic error app if initialization fails
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0D3D30),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Startup Error: $e\n\nPlease check your internet connection or Firebase configuration (google-services.json).",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 14),
            ),
          ),
        ),
      ),
    ));
  }
}
