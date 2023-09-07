import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp_with_sqlite/database/todo_db.dart';
import 'package:todoapp_with_sqlite/model/todo.dart';
import 'package:todoapp_with_sqlite/widget/create_todo_widget.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  Future<List<Todo>>? futureTodos;
  final todoDB = TodoDB();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final todos = snapshot.data ?? [];

            return todos.isEmpty
                ? const Center(
                    child: Text(
                      'No Todos..',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      final subTitle = DateFormat('yyyy/MM/dd').format(
                          DateTime.parse(todo.updatedAt ?? todo.createdAt));
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(subTitle),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await todoDB.delete(todo.id);
                            fetchTodos();
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateTodoWidget(
                              title: todo.title,
                              todo: todo,
                              onSubmit: (title) async {
                                await todoDB.update(id: todo.id, title: title);
                                fetchTodos();
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              title: '',
              onSubmit: (title) async {
                await todoDB.create(title: title);
                fetchTodos() ;
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}
