import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void submit() async {
      final String name = nameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      try {
        UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await db.collection("users").doc(user.user!.uid).set({
          "email": email,
          "username": name,
        });
        print("Registered " + name);
      } catch (e) {
        print(e);
      }
    }

    login() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "SIGN UP",
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Name"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "Username"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: submit,
                  child: Text("SignUp"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(240, 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    InkWell(
                      onTap: login,
                      child: Text("Login"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
