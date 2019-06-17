import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

const _name = "Aung Kyaw Myint";

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() => runApp(new FriendlyChatApp());

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendly Chat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = new TextEditingController();

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          title: Text("Friendly Chat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: ListView.builder(
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                ))
              : null,
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textEditingController.text)
                          : null)
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textEditingController.text)
                          : null,
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: AnimationController(
          duration: new Duration(milliseconds: 400), vsync: this),
    );
    setState(() {
      _isComposing = false;
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
//      opacity: Tween(begin: 0.0,end: 1.0).animate(animationController),
//      opacity: new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
