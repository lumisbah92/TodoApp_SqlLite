import 'package:flutter/material.dart';
import 'package:todoapp_with_sqlite/page/todos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TodoApp With SqlLite',
      home: Scaffold(
        body: TodosPage(),
      ),
    );
  }
}
