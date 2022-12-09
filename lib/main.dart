import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<PatientData> fetchAlbum() async {
  final response = await http.get(
      Uri.parse('https://mocki.io/v1/776227f6-875a-4caf-b1dd-df8cfec37f1e'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("Typwse: " + jsonDecode((response.body)));
    return PatientData.fromJson(jsonDecode(response.body));
  } else {
    print("ERRORRRRRR: " + jsonDecode((response.body)));
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class PatientData {
  final String height;
  final String weight;
  final String age;
  final String gender;

 const PatientData(
      {required this.height,
      required this.weight,
      required this.age,
      required this.gender});

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
        height: json['height'],
        age: json['age'],
        weight: json['weight'],
        gender: json['gender']);
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<PatientData> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    print("MPHKA STHN INIT!!!!!!!!");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<PatientData>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.height);
              } else if (snapshot.hasError) {
                print("ERROR!!!!!!!!!!");
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
