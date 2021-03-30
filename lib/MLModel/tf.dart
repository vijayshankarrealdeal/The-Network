import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

const int kModelInputSize = 64;

class ModelT {
  Future loadModel() async {
    try {
      await Tflite.loadModel(
          model: 'assets/converted_model_final_xe.tflite',
          labels: 'assets/labels.txt');
    } on PlatformException {
      print('Error');
    }
  }

  Future<List> getPred(File file) async {
    List recg = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 1,
    );
    return recg;
  }

  // ignore: missing_return
}
