import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/components/colors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInuser;
final focusNode = FocusNode();

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isKeyboardVisible = false;
  var messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });
    });
  }

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  void dispose() async {
    super.dispose();
    await _auth.signOut();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInuser = user;
        print(loggedInuser);
      }
    } catch (e) {
      print(e);
    }
  }

  void onEmojiSelected(String emoji) => setState(() {
        controller.text = controller.text + emoji;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Messages'),
        backgroundColor: PalletteColors.primaryRed,
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: onBackPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                decoration: new BoxDecoration(
                    border: new Border(
                        top:
                            new BorderSide(color: Colors.blueGrey, width: 0.5)),
                    color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: new Icon(Icons.keyboard_rounded),
                        ),
                      ),
                      color: Colors.white,
                    ),
                    Flexible(
                      child: Container(
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.multiline,
                          focusNode: focusNode,
                          onSubmitted: (value) {
                            controller.clear();
                            _firestore.collection('messages').add({
                              'sender': loggedInuser!.email,
                              'text': messageText,
                              'timestamp': Timestamp.now(),
                            });
                          },
                          maxLines: null,
                          controller: controller,
                          onChanged: (value) {
                            messageText = value;
                          },
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                    ),
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 8.0),
                        child: new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: () {
                            controller.clear();
                            _firestore.collection('messages').add({
                              'sender': loggedInuser!.email,
                              'text': messageText,
                              'timestamp': Timestamp.now(),
                            });
                          },
                          color: Colors.blueGrey,
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String giveUsername(String email) {
  return email.replaceAll(new RegExp(r'@g(oogle)?mail\.com$'), '');
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          // Sort the messages by timestamp DESC because we want the newest messages on bottom.
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // If we do not have data yet, show a progress indicator.
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Create the list of message widgets.

        List<Widget> messageWidgets = snapshot.data!.docs.map<Widget>((m) {
          final data = m.data as dynamic;
          final messageText = data()['text'];
          final messageSender = data()['sender'];
          final currentUser = loggedInuser!.email;
          final timeStamp = data()['timestamp'];
          return MessageBubble(
            sender: messageSender,
            text: messageText,
            timestamp: timeStamp,
            isMe: currentUser == messageSender,
          );
        }).toList();

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.timestamp, this.isMe});
  final String? sender;
  final String? text;
  final Timestamp? timestamp;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${giveUsername(sender!)}",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe!
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color:
                isMe! ? PalletteColors.primaryGrey : PalletteColors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                    isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    text!,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: isMe! ? Colors.white : Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "${DateFormat('h:mm a').format(dateTime)}",
                      style: TextStyle(
                        fontSize: 9.0,
                        color: isMe!
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black54.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
