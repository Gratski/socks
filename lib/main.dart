import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as dev;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(socketChannel: IOWebSocketChannel.connect("ws://192.168.1.92:9091/name")));
  }
}

class MyHomePage extends StatefulWidget {

  final WebSocketChannel socketChannel;
  MyHomePage({Key key, this.socketChannel}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is a socket test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Form(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Entre your message"),
                controller: _editingController,
              ),
            ),
            StreamBuilder(
              stream: widget.socketChannel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData? snapshot.data : 'No data received');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.email),
        onPressed: _sendMessage,
      ),
    );
  }

  void _sendMessage(){
    print("HHGHHHGHGHGHGHGHGHGH");
    String abcd = _editingController.text;
    widget.socketChannel.sink.add("{\"name\" : \"" + abcd + "\"}");
  }

  @override
  void dispose(){
    widget.socketChannel.sink.close();
    super.dispose();
  }
}
