import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;

class ModelRec {
  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/gender_model.tflite',
    );
  }

  Future<List> runModel(img.Image image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: 'assets/2.jpeg', // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    print(recognitions);
    // final recognitions = await Tflite.runModelOnBinary(
    //     binary: imageToByteListFloat32(image, 224, 127.5, 127.5),
    //     numResults: 2, // defaults to 5
    //     threshold: 0.05, // defaults to 0.1
    //     asynch: true);
    // print(recognitions);
    // return recognitions;
  }

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Future<List> loadS() async {
    final ByteData bytes = await rootBundle.load('assets/2.jpeg');
    final Uint8List list = bytes.buffer.asUint8List();
    print(list);
    img.Image imImage = img.decodeImage(list);

    img.Image resizedImage = img.copyResize(
      imImage,
      width: 64,
      height: 64,
    );

    return runModel(resizedImage);
  }
}
