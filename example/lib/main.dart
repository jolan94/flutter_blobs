import 'package:blobs/blobs.dart';
import 'package:example/examples/examples.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.manropeTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xff596275),
              ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.manropeTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const Examples(), // Examples() for all demo
    );
  }
}

class BasicExample extends StatelessWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final blobCtrl = BlobController();
    return Scaffold(
      appBar: AppBar(title: const Text('Blobs Example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Blob.random(
                size: 400,
                controller: blobCtrl,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                BlobData blobData = blobCtrl.change();
                print(blobData);
              },
              child: const Text('Randomize'),
            ),
          ],
        ),
      ),
    );
  }
}
