import 'package:chat_with_firebase/widgets/message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                reverse: true,
                itemCount: chatSnapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    child: MessageCard(
                      message: chatSnapshot.data.documents[index]['text'],
                      isMe: chatSnapshot.data.documents[index]['userId'] ==
                          futureSnapshot.data.uid,
                      key: ValueKey(
                          chatSnapshot.data.documents[index].documentID),
                      username: chatSnapshot.data.documents[index]['username'],
                      userImage: chatSnapshot.data.documents[index]
                          ['userImage'],
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
