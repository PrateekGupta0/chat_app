import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_version1/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



final _firestore = FirebaseFirestore.instance;
 User? loggedInUser;


// final _firestore = FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (await _auth.currentUser != null) {
        loggedInUser = user!;
        // print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                // getMessages();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                       messageTextController.clear();
                       // print(loggedInUser?.email);
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapsot) {
          if (!snapsot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapsot.data!.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = (message.data() as dynamic)['text'];
            final messageSender = (message.data() as dynamic)['sender'];
            final currentUser =loggedInUser?.email;
            // print(currentUser);
            // print(messageSender);
            final messageBubble =
            MessageBubble(text: messageText, sender: messageSender,isMe: currentUser == messageSender,);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        });
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender,required this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?
        CrossAxisAlignment.end:
          CrossAxisAlignment.start,
          children: [
        Text(sender,style: TextStyle(
          fontSize: 12.0,
          color: Colors.black54,
        ),),
        Material(
          borderRadius:  isMe ?BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):BorderRadius.only(topRight: Radius.circular(30.0),bottomRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0)),
          elevation: 10.0,
          color: isMe ?Colors.lightBlueAccent:Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ?Colors.white:Colors.black54,
                fontSize: 25.0,
              ),
            ),
          ),
        ),
      ]),
    );
    ;
  }
}
