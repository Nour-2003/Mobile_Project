import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: HexColor("121212"), // Dark background
  iconTheme: IconThemeData(color: Colors.white), // White icons
  primarySwatch: Colors.deepOrange,
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFF00B96D), // Green for selected item
    unselectedItemColor: Colors.grey, // Dimmed white for unselected items
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white, // White background for the bottom bar
  ),
  appBarTheme: AppBarTheme(
    actionsIconTheme: IconThemeData(color: Colors.white), // White icons
    titleSpacing: 20,
    backgroundColor: Color(0xFF00B96D), // Green app bar
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Green status bar
      statusBarIconBrightness: Brightness.light, // Light icons
    ),
    titleTextStyle: GoogleFonts.montserrat(
      color: Colors.white, // White app bar text
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white), // White icons
    elevation: 10.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
suffixIconColor: Colors.white,
    prefixIconColor: Colors.white,
    filled: true,
    iconColor: Colors.white, // White icon color
    fillColor: Colors.grey.shade800, // Darker input field background
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color(0xFF00B96D), // Green border when focused
      ),
    ),
    hintStyle: TextStyle(color: Colors.white), // White hint text
    labelStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18), // White label text
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),

    focusColor: Colors.white,
    helperStyle: TextStyle(color: Colors.white), // Helper text style (optional)
    errorStyle: TextStyle(color: Colors.red), // Error text style (optional)
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFF00B96D)), // Green background
      foregroundColor: MaterialStateProperty.all(Colors.white), // White text
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)), // Green text
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(color: Color(0xFF00B96D))), // Green border
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)), // Green text
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  iconTheme: IconThemeData(color: Colors.black), // Black icons for light theme
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFF00B96D), // Green for selected item
    unselectedItemColor: Colors.grey, // Grey for unselected items
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white, // White background for the bottom bar
  ),
  appBarTheme: AppBarTheme(
    actionsIconTheme: IconThemeData(color: Colors.white), // White icons
    centerTitle: true,
    titleSpacing: 20,
    backgroundColor: Color(0xFF00B96D), // Green app bar
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Green status bar
      statusBarIconBrightness: Brightness.dark, // Light icons
    ),
    titleTextStyle: GoogleFonts.montserrat(
      color: Colors.white, // White app bar text
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white), // White icons
    elevation: 10.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    suffixIconColor: Colors.black,
    filled: true,
    fillColor: Colors.white, // Light background for input field
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.grey, // Grey border
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color(0xFF00B96D), // Green border when focused
      ),
    ),

    hintStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFF00B96D)), // Green background
      foregroundColor: MaterialStateProperty.all(Colors.white), // White text
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)), // Green text
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(color: Color(0xFF00B96D))), // Green border
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)), // Green text
    ),
  ),
);
