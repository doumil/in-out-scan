// @dart=2.9
import 'dart:io';
import 'package:buzz_in_out_scann/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = new PostHttpOverrides();
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
class PostHttpOverrides extends HttpOverrides{
  @override
HttpClient createHttpClient(SecurityContext context){
  return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
}
}