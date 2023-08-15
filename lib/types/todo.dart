import 'package:flutter/material.dart';

class Todo {
  String name;
  bool completed;

  Todo({required this.name, required this.completed});

  Todo.fromJson(Map<String, dynamic> json)
      : name = json["n"],
        completed = json["c"];

  Map<String, dynamic> toJson() {
    return {
      "n": name,
      "c": completed,
    };
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final void Function(Todo todo) handleTodoCompletedChange;
  final void Function(Todo todo) handleTodoDelete;
  final void Function(Todo todo)? handleTodoClick;

  TodoItem(
      {required this.todo,
      required this.handleTodoCompletedChange,
      required this.handleTodoDelete,
      this.handleTodoClick})
      : super(key: ObjectKey(todo));

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (handleTodoClick != null) {
          handleTodoClick!(todo);
        }
      },
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value: todo.completed,
        onChanged: (value) => handleTodoCompletedChange(todo),
      ),
      title: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            todo.name,
            style: _getTextStyle(todo.completed),
          )),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => handleTodoDelete(todo),
            iconSize: 30,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}
