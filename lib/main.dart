import 'package:flutter/material.dart';
import 'package:learn_flutter/components/alert_dialog.dart';
import 'package:learn_flutter/storage/todo_storage.dart';
import 'package:learn_flutter/types/Todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const TodoHomePage(title: 'Todo Manager: Home Page'),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  // int _counter = 0;
  final TodoStorage todoStorage = TodoStorage();
  List<Todo> _todos = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _editTodoTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    todoStorage.readTodos().then((storedTodos) => {
          setState(() {
            _todos = storedTodos;
          })
        });
  }

  // void _incrementCounter() {
  //   setState(() {
  // This call to setState tells the Flutter framework that something has
  // changed in this State, which causes it to rerun the build method below
  // so that the display can reflect the updated values. If we changed
  // _counter without calling setState(), then the build method would not be
  // called again, and so nothing would appear to happen.
  // _counter++;
  //   });
  // }

  void _addTodo(String name) {
    setState(() {
      _todos.add(Todo(name: name, completed: false));
    });
    _textFieldController.clear();
    todoStorage.saveTodos(_todos);
  }

  void _handleTodoCompletedChange(Todo todo) {
    final todoIdx = _todos.indexOf(todo);
    if (todoIdx == -1) return;

    setState(() {
      _todos[todoIdx].completed = !_todos[todoIdx].completed;
    });
    todoStorage.saveTodos(_todos);
  }

  void _handleTodoDelete(Todo todo) {
    final todoIdx = _todos.indexOf(todo);
    if (todoIdx == -1) return;

    setState(() {
      _todos.removeAt(todoIdx);
    });
    todoStorage.saveTodos(_todos);
  }

  Future<void> _openAddTodoDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
              title: "Add a Todo",
              content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: "Type your todo"),
                autofocus: true,
              ),
              onSecondaryButtonPress: () {
                _textFieldController.clear();
              },
              primaryButtonText: "Add",
              onPrimaryButtonPress: () => _addTodo(_textFieldController.text));
        });
  }

  void _handleTodoEdit(Todo todo) {
    if (todo.name == _editTodoTextFieldController.text) return;

    final todoIdx = _todos.indexOf(todo);
    if (todoIdx == -1) return;

    setState(() {
      _todos[todoIdx].name = _editTodoTextFieldController.text;
    });

    _editTodoTextFieldController.clear();
    todoStorage.saveTodos(_todos);
  }

  Future<void> _openEditTodoDialog(Todo todo) async {
    _editTodoTextFieldController.text = todo.name;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: "Edit Todo",
            content: TextField(
              controller: _editTodoTextFieldController,
              decoration: const InputDecoration(hintText: "Edit your todo"),
              autofocus: true,
            ),
            primaryButtonText: "Confirm",
            onPrimaryButtonPress: () => _handleTodoEdit(todo),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos
            .map((Todo todo) => TodoItem(
                  todo: todo,
                  handleTodoCompletedChange: _handleTodoCompletedChange,
                  handleTodoDelete: _handleTodoDelete,
                  handleTodoClick: _openEditTodoDialog,
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodoDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        // child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: <Widget>[],
          // children: <Widget>[
          //   const Text(
          //     'You have pushed the button this many times:',
          //   ),
          //   Text(
          //     '$_counter',
          //     style: Theme.of(context).textTheme.headlineMedium,
          //   ),
          // ],
      //   ),
      // )