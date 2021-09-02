import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'dart:io';

class Post extends StatefulWidget {
  final Map data;
  Post(this.data);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  String imagePath = "";

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deletePost() async {
      try {
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").doc(widget.data['id']).delete();

        print("Successfully Deleted");
      } catch (e) {
        print("delete Error ===>  $e");
      }
    }

    updatePost() {
      try {
        void pickImage() async {
          final ImagePicker _picker = ImagePicker();
          final image = await _picker.pickImage(source: ImageSource.gallery);
          setState(() {
            imagePath = image!.path;
          });
        }

        updated() async {
          try {
            // image inserted in storage
            String imageName = path.basename(imagePath);
            firebase_storage.Reference ref =
                firebase_storage.FirebaseStorage.instance.ref("/$imageName");
            File file = File(imagePath);
            await ref.putFile(file);
            String downloadUrl = await ref.getDownloadURL();

            // data updated in firestore
            FirebaseFirestore db = FirebaseFirestore.instance;
            await db.collection("posts").doc(widget.data['id']).set({
              "title": titleController.text,
              "description": descriptionController.text,
              "url": downloadUrl
            });

            // back to main screen
            Navigator.of(context).pop();

            print("Successfully Updated");
          } catch (e) {
            print("updated error ===> $e");
          }
        }

        showDialog(
            context: context,
            builder: (BuildContext build) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      child: Text("Pick Image"),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 30),
                      ),
                    ),
                    ElevatedButton(onPressed: updated, child: Text("Submit")),
                  ],
                ),
              );
            });
      } catch (e) {
        print("update Error ===>  $e");
      }
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              widget.data['url'],
              width: 100,
              height: 400,
            ),
            title: new Text(
              widget.data['title'],
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: new Text(widget.data['description']),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: deletePost, child: Text("Delete")),
              ElevatedButton(onPressed: updatePost, child: Text("Update")),
            ],
          ),
        ],
      ),
    );
  }
}
