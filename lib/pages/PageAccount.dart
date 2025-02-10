import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/LanguageProvider.dart';
import '../providers/LoginProvider.dart';

class PageAccount extends StatelessWidget {
  const PageAccount({super.key});

  void login(LoginProvider loginProv, String email, String password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      loginProv.login(FirebaseAuth.instance.currentUser!);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Wrong Email or Password!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        // forceMaterialTransparency: true,

        title: Text("Account"),
      ),
      body: Consumer<LoginProvider>(
        builder: (context, loginProv, child) {
          if (LoginProvider.user == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) => email = value,
                      onSubmitted: (value) =>
                          {login(loginProv, email, password, context)},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSubmitted: (value) =>
                          {login(loginProv, email, password, context)},
                      obscureText: true,
                      onChanged: (value) => password = value,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        login(loginProv, email, password, context);
                      },
                      label: Text("Login"),
                      icon: Icon(Icons.person),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () => {
                        if (email.isEmpty)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please Enter Valid Email!")))
                          }
                        else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              contentPadding: EdgeInsets.only(top: 18, left: 18),
                              actionsPadding: EdgeInsets.all(10),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              insetPadding: EdgeInsets.all(0),
                              content: Text(
                                LanguageProvider.getMap()["general"]["sure"],
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: [
                                TextButton.icon(
                                  onPressed: () async => {
                                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email),
                                    Navigator.of(context).pop(),
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text("Password Reset Link Sent To: $email")))
                                  },
                                  label: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color:
                                        Theme.of(context).colorScheme.onSurface),
                                  ),
                                  icon: Icon(
                                    Icons.password_rounded,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => {Navigator.of(context).pop()},
                                  label: Text(
                                      LanguageProvider.getMap()["general"]["cancel"]),
                                  icon: Icon(Icons.arrow_back),
                                )
                              ],
                            ),
                          ),
                        }
                      },
                      child: Text("Forgot Password?"),
                    )
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LoginProvider.user!.email!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.only(top: 18, left: 18),
                        actionsPadding: EdgeInsets.all(10),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        insetPadding: EdgeInsets.all(0),
                        content: Text(
                          LanguageProvider.getMap()["general"]["sure"],
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton.icon(
                            onPressed: () async => {
                              await FirebaseAuth.instance.signOut(),
                              loginProv.logout(),
                              Navigator.of(context).pop()
                            },
                            label: Text(
                              "Logout",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            icon: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => {Navigator.of(context).pop()},
                            label: Text(
                                LanguageProvider.getMap()["general"]["cancel"]),
                            icon: Icon(Icons.arrow_back),
                          )
                        ],
                      ),
                    );
                  },
                  label: Text("Logout"),
                  icon: Icon(Icons.person),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
