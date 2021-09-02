import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'dart:io';

class View extends StatefulWidget {
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('posts').snapshots();
  String imagePath = "";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image!.path;
      });
    }

    void submit() async {
      String title = titleController.text;
      String description = descriptionController.text;
      try {
        // image inserted in storage
        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref("/$imageName");
        File file = File(imagePath);
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();

        // data inserted in firestore
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").add(
            {"title": title, "description": description, "url": downloadUrl});
        print("Succesfully Inserted");
      } catch (e) {
        print("error ===>  $e");
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Enter title",
                ),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Enter Description",
                ),
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Image Upload"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 35),
                ),
              ),
              ElevatedButton(onPressed: submit, child: Text("Submit")),
              Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return new ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        data['id'] = document.id;
                        return Post(data);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
