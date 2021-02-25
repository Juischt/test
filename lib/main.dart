import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ToDoList()));

class SingleToDo extends StatelessWidget {
  final String title;
  final bool done;
  final bool chosen;
  final Function remove;
  final Function toggleDone;
  final Function hover;
  final Function dragToDo;
  const SingleToDo(this.title, this.done, this.chosen , this.remove, this.toggleDone, this.hover, this.dragToDo);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () => hover(),
        onDoubleTap: () => dragToDo(),
        //onHorizontalDragDown: (e) => ,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: chosen
                ? Colors.teal
                : Colors.black12,
            border: Border.all(color: Colors.black45, width: 2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 22,
          ),
          child: ListTile(

              leading: Checkbox(
                value: done,
                onChanged: (bool value) => toggleDone(),
                checkColor: chosen
                    ? Colors.teal
                    : Colors.white,
                activeColor: chosen
                    ? Colors.white
                    : Colors.teal,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: done ? "Lucida" : "Arial",
                  fontStyle: done ? FontStyle.italic : FontStyle.normal,
                  color: chosen
                      ? Colors.white
                      : Colors.teal,
                  decoration:
                  done ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: chosen
                      ? Colors.white
                      : Colors.teal,
                ),
                onPressed: () => remove(),
              )),

        )
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Map<String, bool> ToDos = {};
  Map<String, bool> chosenToDo = {};
  Map<int, bool> switchToDos = {};

  void addToDo(String item) {
    setState(() {
      ToDos[item] = false;
      chosenToDo[item] = false;
    });
    Navigator.of(context).pop();
  }

  void deleteToDo(key) {
    setState(() {
      ToDos.remove(key);
      chosenToDo.remove(key);
    });
  }

  void toggleDone(String key) {
    setState(() {
      ToDos.update(key, (bool done) => !done);
    });
  }

  void hover(String key) {
    setState(() {
      chosenToDo.update(key, (bool chosen) => !chosen);
    });
  }

  void dragToDo(String key, String key2) {

    setState(() {
      switchToDos[1] = ToDos[key];
      ToDos[key] = ToDos[key2];
      ToDos[key2] = switchToDos[1];

      ToDos.update(key, (bool done) => !done);
      ToDos.update(key2, (bool done) => done);
    });
  }

  void newEntry() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              onSubmitted: addToDo,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Neuer ToDo Eintrag',
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo Liste',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Arial",
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: ToDos.length,
        itemBuilder: (context, i) {
          String key = ToDos.keys.elementAt(i);
          String key2 = ToDos.keys.elementAt(i++);

          return SingleToDo(
            key,
            ToDos[key],
            chosenToDo[key],
                () => deleteToDo(key),
                () => toggleDone(key),
                () => hover(key),
                () => dragToDo(key, key2),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newEntry,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
