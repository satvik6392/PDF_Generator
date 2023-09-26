import 'package:flutter/material.dart';
import 'package:pdf_viewer/pdf_provider.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PdfProvider>(create: (_)=>PdfProvider(),)
      ],
      child:const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
