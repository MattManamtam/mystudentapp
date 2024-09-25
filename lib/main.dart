// main.dart
import 'package:flutter/material.dart';
import 'list_screen.dart';  // Student list screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Define the primary and secondary colors
  final Color primaryColor = Colors.lightBlue; // Sky blue
  final Color secondaryColor = Colors.orangeAccent; // Complementary color

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: secondaryColor, // Replace accentColor with secondary
        ),
        scaffoldBackgroundColor: Colors.white, // White background
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryColor, // Use secondary color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: primaryColor, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all<Color>(secondaryColor),
          trackColor: MaterialStateProperty.all<Color>(secondaryColor.withOpacity(0.5)),
        ),
      ),
      home: StudentListScreen(),  // Go to the student list screen first
    );
  }
}
