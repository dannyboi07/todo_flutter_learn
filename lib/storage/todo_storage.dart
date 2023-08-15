import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:learn_flutter/types/Todo.dart';

class TodoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File("$path/todo.json");
  }

  Future<List<Todo>> readTodos() async {
    List<Todo> todos = [];
    try {
      final file = await _localFile;

      final String contents = await file.readAsString();
      var todosJsonEncoded = jsonDecode(contents);

      for (var todo in todosJsonEncoded) {
        todos.add(Todo.fromJson(todo));
      }
    } catch (e) {
      return todos;
    }

    return todos;
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final file = await _localFile;

    file.writeAsString(json.encode(todos));
  }
}
