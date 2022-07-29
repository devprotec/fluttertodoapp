import 'package:flutter/material.dart';
import 'package:fluttertodoapp/authen/signup_login.dart';
import 'package:fluttertodoapp/database/databasehelper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageStateless extends StatelessWidget {
  final String studentName;
  const HomePageStateless({Key? key, required this.studentName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        studentName: studentName,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String? studentName;
  const HomePage({Key? key, required this.studentName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String dateTime = "";

  Color getColor(Set<MaterialState> states) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "To-dos",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: FutureBuilder<List<Task>>(
        future: DatabaseHelper.instance.getTask(),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: Text(
              "Loading",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ));
          }
          return ListView(
            children: snapshot.data!.map((task) {
              bool? isDone = task.status == "DONE" ? true : false;
              return Center(
                  child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      create_Update(task.title, task.dateTime, false,
                          task.status, task.id);
                    });
                  },
                  icon: const Icon(Icons.update),
                  color: Colors.white,
                ),
                title: Text(task.title,
                    style: !isDone
                        ? const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)
                        : const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.lineThrough)),
                subtitle: Text(
                  task.dateTime,
                  style: !isDone
                      ? const TextStyle(color: Colors.white)
                      : const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough),
                ),
                trailing: Checkbox(
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  checkColor: Colors.purple,
                  onChanged: (bool? change) {
                    setState(() {
                      DatabaseHelper.instance.changeStatus(task);
                    });
                  },
                  value: isDone,
                ),
                onLongPress: () {
                  remove(task.id!);
                },
              ));
            }).toList(),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await create_Update(title, dateTime, true);
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: _drawer(widget.studentName!),
    );
  }

  Future<bool?> create_Update(String title, String dateTime, bool isCreate,
      [String? status, int? id]) {
    return Alert(
        style: const AlertStyle(backgroundColor: Colors.white),
        context: context,
        title: isCreate ? "NEW TO-DO" : "UPDATE",
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                initialValue: !isCreate ? title : null,
                validator: ((title) {
                  if (title!.isEmpty) {
                    return "title cannot be empty";
                  } else {
                    return null;
                  }
                }),
                onChanged: (newTitle) => title = newTitle,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.title,
                    color: Colors.purple,
                  ),
                  labelText: "Task Title",
                ),
              ),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyy',
              initialValue: isCreate
                  ? DateTime.now().toString()
                  : DateTime.parse(dateTime).toString(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              icon: const Icon(
                Icons.event,
                color: Colors.purple,
              ),
              dateLabelText: "Date",
              timeLabelText: "Time",
              onChanged: (newDate) => dateTime = newDate,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.purple,
            onPressed: () {
              isCreate
                  ? _onCreate(title, dateTime)
                  : _upDate(Task(
                      id: id,
                      title: title,
                      dateTime: dateTime,
                      status: status!));
            },
            child: Text(
              isCreate ? "Create" : "Update",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]).show();
  }

  Future<void> _onCreate(String title, String dateTime) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      setState(() {
        DatabaseHelper.instance
            .add(Task(title: title, dateTime: dateTime, status: "ACTIVE"));
      });
    }
  }

  _upDate(Task task) {
    setState(() {
      Navigator.of(context).pop();
      DatabaseHelper.instance.update(task);
    });
  }

  remove(int id) {
    return Alert(
        context: context,
        type: AlertType.warning,
        title: "DELETE ALERT",
        desc: "Are you sure you want to delete this task?",
        buttons: [
          DialogButton(
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
                DatabaseHelper.instance.remove(id);
              });
            },
            color: Colors.red,
          ),
          DialogButton(
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.purple,
          )
        ]).show();
  }

  Widget _drawer(String studentName) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  studentName,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              )),
          _drawerListTile("Account", Icons.manage_accounts, false, false),
          _drawerListTile("Settings", Icons.settings, false, false),
          _drawerListTile("More", Icons.more, false, true),
          _drawerListTile(
            "Logout",
            Icons.logout,
            true,
            false,
          ),
        ],
      ),
    );
  }

  Widget _drawerListTile(
      String textData, IconData iconData, bool isLogout, bool isMore) {
    return ListTile(
        title: Text(
          textData,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: Icon(iconData, size: 30),
        onTap: () {
          Navigator.of(context).pop();
          isLogout
              ? FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignupLogin())))
              : null;
          isMore
              ? Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MorePage()))
              : null;
        });
  }
}

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
          body: Center(
        child: Text("This is the more page"),
      )),
    );
  }
}
