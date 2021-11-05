import 'package:flutter/material.dart';
import 'package:todoz/models/todo_model.dart';
import 'package:todoz/screens/tododetail.dart';
import 'package:todoz/services/database_service.dart';
import 'package:intl/intl.dart';
import 'createtodo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = false;
  List<Todo> _todos = [];

  @override
  void initState() {
    getallTodos();
    super.initState();
  }

  @override
  void dispose() {
    DatabaseService().close();
    super.dispose();
  }

  Future getallTodos() async {
    if (mounted) {
      setState(() => isloading = true);

      _todos = await DatabaseService().readallTodos();

      setState(() => isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  child: _todos.isEmpty
                      ? Center(
                          child: Text(
                            'No Todos',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        )
                      : CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              expandedHeight: size.height * 0.24,
                              backgroundColor: Colors.white,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Image.asset(
                                  'assets/todoimg.png',
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  'Todos',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                ),
                                centerTitle: true,
                              ),
                            ),
                            SliverList(
                                delegate: SliverChildListDelegate([
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _todos.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final todo = _todos[index];
                                            final time = DateFormat.yMMMd()
                                                .format(todo.createdTime);
                                            return Card(
                                              color: Colors.amber,
                                              shadowColor: Colors.blueGrey,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TodoDetail(
                                                                updateTodos:
                                                                    getallTodos,
                                                                todoid:
                                                                    todo.id!,
                                                              )));
                                                  getallTodos();
                                                },
                                                child: ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('${todo.title}'),
                                                      Text('$time'),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${todo.description}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ]))
                          ],
                        ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTodoScreen(
                    updateTodos: getallTodos,
                  )));
          getallTodos();
        },
      ),
    );
  }
}
