import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          PopupMenuButton<String>(
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (String value) async {
              switch (value) {
                case 'logout':
                  {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (ctx) {
                        return LoginPage();
                      }));
                    });
                  }
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter Green House id',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter Email id',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String greenHouseId = _textController.text;
                String emailId = _emailController.text.toLowerCase();

                // Firestore document reference
                DocumentReference docRef = FirebaseFirestore.instance
                    .collection('greenhouse')
                    .doc(emailId);

                // Add data to Firestore
                await docRef.set({
                  'green_id': greenHouseId,
                });

                // Show a snackbar to indicate success
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data submitted successfully')));

                // Clear text fields after submission
                _textController.clear();
                _emailController.clear();
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
