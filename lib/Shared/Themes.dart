import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: HexColor("121212"),
  iconTheme: IconThemeData(color: Colors.white),
  primarySwatch: Colors.deepOrange,
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFF00B96D),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    actionsIconTheme: IconThemeData(color: Colors.white),
    titleSpacing: 20,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Color(0xFF00B96D),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 10.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    suffixIconColor: Colors.white,
    prefixIconColor: Colors.white,
    filled: true,
    iconColor: Colors.white,
    fillColor: Colors.grey.shade800,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color(0xFF00B96D),
      ),
    ),
    hintStyle: TextStyle(color: Colors.white),
    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
    focusColor: Colors.white,
    helperStyle: TextStyle(color: Colors.white),
    errorStyle: TextStyle(color: Colors.red),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFF00B96D)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(color: Color(0xFF00B96D))),
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade800,
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.white, // White icon color
    tileColor: Colors.grey.shade800, // Darker background for list items
    textColor: Colors.white, // White text color
    selectedTileColor: Color(0xFF00B96D), // Green for selected list items
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding inside ListTile
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  iconTheme: IconThemeData(color: Colors.black),
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
    selectedItemColor: Color(0xFF00B96D),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    actionsIconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    titleSpacing: 20,
    backgroundColor: Color(0xFF00B96D),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 10.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    suffixIconColor: Colors.black,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color(0xFF00B96D),
      ),
    ),
    hintStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFF00B96D)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(color: Color(0xFF00B96D))),
      foregroundColor: MaterialStateProperty.all(Color(0xFF00B96D)),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.black, // Black icon color for light theme
    tileColor: Colors.white, // White background for list items
    textColor: Colors.black, // Black text color
    selectedTileColor: Color(0xFF00B96D), // Green for selected list items
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding inside ListTile
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
    ),
  ),
);
