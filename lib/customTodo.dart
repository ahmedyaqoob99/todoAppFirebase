import 'package:flutter/material.dart';

class CustomTodo extends StatefulWidget {
  @override
  _CustomTodoState createState() => _CustomTodoState();
}

class _CustomTodoState extends State<CustomTodo> {
  var data = "";

  List<dynamic> items = [1, 2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: Colors.amber,
              // contentPadding: EdgeInsets.all(4),
              leading: Text("${items[index]}"),
              trailing: Container(
                  width: 70,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Edit Text"),
                                content: TextField(
                                  onChanged: (value) {
                                    data = value;
                                  },
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        items.replaceRange(
                                            index, index + 1, {data});
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Edited"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.edit),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            items.removeAt(index);
                          });
                        },
                        child: Icon(Icons.delete),
                      ),
                    ],
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Enter Text"),
                content: TextField(
                  onChanged: (value) {
                    data = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          items.add(data);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("Submit"))
                ],
              );
            },
          );
        },
        child: Text("Add"),
      ),
    );
  }
}
