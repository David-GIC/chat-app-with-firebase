import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var enterMessage = '';
  TextEditingController controller = TextEditingController();
  void sendMessage() async {
    print("Called Send Message");
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': enterMessage,
      'createdAt': DateTime.now(),
      'userId': user.uid,
      'username': userData['username']
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Send a message ...'),
            onChanged: (value) {
              setState(() {
                enterMessage = value;
                print(enterMessage);
              });
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: () => enterMessage.trim().isEmpty ? null : sendMessage(),
          )
        ],
      ),
    );
  }
}
