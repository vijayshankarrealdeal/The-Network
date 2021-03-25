import 'dart:async';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

const int kModelInputSize = 64;

class ModelT {
  Future loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
          model: 'assets/converted_model_final_xe.tflite',
          labels: 'assets/labels.txt');
    } on PlatformException {
      print('Error');
    }
  }

  Future<List> predictImage(String image) async {
    return await Tflite.runModelOnImage(path: image);
  }
}
