import 'package:flutter/material.dart';
import 'package:todoz/models/todo_model.dart';
import 'package:todoz/screens/createtodo.dart';
import 'package:todoz/services/database_service.dart';

class TodoDetail extends StatefulWidget {
  final int todoid;
  final VoidCallback? updateTodos;
  TodoDetail({required this.todoid, this.updateTodos});
  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  late Todo todo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshtodos();
  }

  Future<void> refreshtodos() async {
    setState(() => isLoading = true);

    todo = await DatabaseService().readTodo(widget.todoid);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Todo Details',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: ListView(
                children: [
                  Text(
                    '${todo.title}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    '${todo.description}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  editbutton(),
                  deletebutton(),
                ],
              ),
            ),
    );
  }

  Widget editbutton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.amber,
      ),
      child: Text('Edit'),
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddTodoScreen(
                  todo: todo,
                  updateTodos: widget.updateTodos,
                )));
        refreshtodos();
      },
    );
  }

  Widget deletebutton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.red,
      ),
      child: Text('Delete'),
      onPressed: () async {
        await DatabaseService().deleteTodo(widget.todoid);
        Navigator.of(context).pop();
        widget.updateTodos!();
      },
    );
  }
}
