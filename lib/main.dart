import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

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
  File file;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // ignore: missing_return
  Future<List> runModel(File file) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
          path: file.path,
          imageMean: 0.0, // defaults to 117.0
          imageStd: 255.0, // defaults to 1.0
          numResults: 2, // defaults to 5
          threshold: 0.2, // defaults to 0.1
          asynch: true);

      print(recognitions);
      return recognitions;
    } catch (e) {
      print(e.message);
    }
  }

  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/gender_model.tflite',
      labels: 'assets/labels.txt',
    );
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
                onPressed: () {
                  runModel(file);
                })
          ],
        ),
      ),
    );
  }
}
