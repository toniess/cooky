import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), backgroundColor: Colors.brown[700]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(decoration: InputDecoration(hintText: 'Search...', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[300])),
          ),
          RecipeCard(),
          BottomAppBar(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Icon(Icons.favorite_border), Icon(Icons.book), Icon(Icons.settings)]),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Pizza'),
          ],
        ),
      ],
    );
  }
}
