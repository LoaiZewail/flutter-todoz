import 'package:flutter/material.dart';
import 'package:todoz/models/todo_model.dart';
import 'package:todoz/services/database_service.dart';

class AddTodoScreen extends StatefulWidget {
  final VoidCallback? updateTodos;
  final Todo? todo;
  AddTodoScreen({this.todo, required this.updateTodos});
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    title = widget.todo?.title ?? '';
    description = widget.todo?.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          _isEditing ? 'Update Todo' : 'Add Todo',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    initialValue: title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'The title cannot be empty'
                        : null,
                    onChanged: (title) => this.title = title,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    initialValue: description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: EdgeInsets.all(20),
                    ),
                    validator: (description) =>
                        description != null && description.isEmpty
                            ? 'The description cannot be empty'
                            : null,
                    onChanged: (description) => this.description = description,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
            ),
            buildbutton(),
          ],
        ),
      ),
    );
  }

  Widget buildbutton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.amber,
      ),
      child: Text(_isEditing ? 'Update' : 'Save'),
      onPressed: () async {
        if (_isEditing) {
          print('updating todo ..');
          final todo = widget.todo?.copy(
            title: title,
            description: description,
          );
          await DatabaseService()
              .updateTodo(todo!)
              .then((value) => print('todo updated'));
        } else {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final todo = Todo(
              title: title,
              description: description,
              createdTime: DateTime.now(),
            );
            await DatabaseService().create(todo);
          }
        }
        Navigator.of(context).pop();
        widget.updateTodos!();
      },
    );
  }

  Future addTodo() async {}

  Future updateTodo() async {}
}
