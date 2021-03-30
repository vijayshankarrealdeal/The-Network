import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hex/MLModel/tf.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ModelT g = ModelT();
  File file;

  final picker = ImagePicker();
  @override
  void initState() {
    g.loadModel();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            file == null ? Text('') : Image.file(file),
            CupertinoButton(
                child: Text('Select Image'), onPressed: () => getImage()),
            CupertinoButton(
                child: Text('Press'),
                onPressed: () async {
                  final res = await g.getPred(file);
                  print(res);
                })
          ],
        ),
      ),
    );
  }
}
