import 'package:flutter/material.dart';
import 'package:stationsathi/map.dart';

const situmApiKey = "Yb38b08aede4f03ec49b37ee4c80b39a616e7227836489339edca43f96abb8c6c";
const buildingIdentifier = "17172";



void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Situm Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

