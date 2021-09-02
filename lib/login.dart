import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: "shafiq@gmail.com");
    final TextEditingController passwordController =
        TextEditingController(text: "123456");

    void login() async {
      final String email = emailController.text;
      final String password = passwordController.text;

      print("email ==> $email");
      print("pass ==> $password");
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        final DocumentSnapshot snapshot =
            await db.collection("users").doc(user.user!.uid).get();
        final data = snapshot.data();
        print("User is Logined in");
        Navigator.of(context).pushNamed("/view");
        print(data);
      } catch (e) {
        print("Error");

        showDialog(
            context: context,
            builder: (BuildContext build) {
              return AlertDialog(content: Text(e.toString()));
            });
      }
    }

    register() {
      Navigator.of(context).pushNamed("/register");
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
                  "LOGIN",
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(height: 40),
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
                  onPressed: login,
                  child: Text("Login"),
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
                    Text("Don't have an account? "),
                    InkWell(
                      onTap: register,
                      child: Text("Register"),
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
