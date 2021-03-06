// import 'package:english_words/english_words.dart' as english_words;
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;

// import './todo_item.dart' show TodoItem, TodoItemAdapter;

// class HiveExample extends StatefulWidget {
//   const HiveExample({Key key}) : super(key: key);

//   @override
//   _HiveExampleState createState() => _HiveExampleState();
// }

// class _HiveExampleState extends State<HiveExample> {
//   static const kHiveFolder = 'hive';
//   static const kHiveBoxName = 'todosBox';

//   Future<bool> _initDbFuture;

//   @override
//   void initState() {
//     super.initState();
//     this._initDbFuture = this._initDb();
//   }

//   // Initializes the hive DB, once done the hive operations are synchronous.
//   Future<bool> _initDb() async {
//     // Initialize hive.
//     final dir = await path_provider.getApplicationDocumentsDirectory();
//     final hiveFolder = join(dir.path, kHiveFolder);
//     Hive.init(hiveFolder);
//     try {

//       Hive.registerAdapter(TodoItemAdapter());
//     } on HiveError catch (e) {
//       print(e);
//     }

//     await Hive.openBox<TodoItem>(kHiveBoxName);
//     final List<TodoItem> todos = _getTodoItems();
//     print('Hive initialization done, todo items in the db are:');
//     todos.forEach(print);
//     return true;
//   }

//   @override
//   void dispose() {
//     Hive.box(kHiveBoxName).compact();
//     Hive.close();
//     super.dispose();
//   }

//   List<TodoItem> _getTodoItems() {
//     final box = Hive.box<TodoItem>(kHiveBoxName);
//     return box.values.toList();
//   }

//   Future<void> _addTodoItem(TodoItem todo) async {
//     final box = Hive.box<TodoItem>(kHiveBoxName);
//     int key = await box.add(todo);
//     // Set the id field to the auto-incremented key.
//     todo.id = key;
//     await todo.save();
//     print('Inserted: key=$key, value=$todo');
//   }

//   Future<void> _toggleTodoItem(TodoItem todo) async {
//     // Note the `todo` must already been added to the hive box.
//     todo.isDone = !todo.isDone;
//     await todo.save();
//     print('Updated: key=${todo.id}, value=$todo');
//   }

//   // Deletes records in the db table.
//   Future<void> _deleteTodoItem(TodoItem todo) async {
//     // Note the `todo` must already been added to the hive box.
//     await todo.delete();
//     print('Delted: key=${todo.id}, value=$todo');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: this._initDbFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         return Scaffold(
//           body: ValueListenableBuilder<Box<TodoItem>>(
//             valueListenable: Hive.box<TodoItem>(kHiveBoxName).listenable(),
//             builder: (context, box, _) => ListView(
//               children: <Widget>[
//                 for (TodoItem item in box.values) _itemToListTile(item)
//               ],
//             ),
//           ),
//           floatingActionButton: _buildFloatingActionButton(),
//         );
//       },
//     );
//   }

//   ListTile _itemToListTile(TodoItem todo) => ListTile(
//     title: Text(
//       todo.content,
//       style: TextStyle(
//           fontStyle: todo.isDone ? FontStyle.italic : null,
//           color: todo.isDone ? Colors.grey : null,
//           decoration: todo.isDone ? TextDecoration.lineThrough : null),
//     ),
//     subtitle: Text('id=${todo.id}\ncreated at ${todo.createdAt}'),
//     isThreeLine: true,
//     leading: IconButton(
//       icon: Icon(
//           todo.isDone ? Icons.check_box : Icons.check_box_outline_blank),
//       onPressed: () => _toggleTodoItem(todo),
//     ),
//     trailing: IconButton(
//       icon: Icon(Icons.delete),
//       onPressed: () => _deleteTodoItem(todo),
//     ),
//   );

//   FloatingActionButton _buildFloatingActionButton() {
//     return FloatingActionButton(
//       child: Icon(Icons.add),
//       onPressed: () async {
//         await _addTodoItem(
//           TodoItem(
//             content: english_words.generateWordPairs().first.asPascalCase,
//           ),
//         );
//       },
//     );
//   }
// }