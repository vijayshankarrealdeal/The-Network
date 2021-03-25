import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as im;
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

  // ignore: missing_return
  Future<List> canvasPt(File file) async {
    Uint8List m = File(file.path).readAsBytesSync();

    im.Image imImage = im.decodeImage(m);
    im.Image resizedImage = im.copyResize(
      imImage,
      width: kModelInputSize,
      height: kModelInputSize,
    );
    print(resizedImage.length);
    var x = imageToByteListFloat32(resizedImage);
    print(x);
    return predictImage(resizedImage);
  }

  Future<List> predictImage(im.Image image) async {
    return await Tflite.runModelOnBinary(
      numResults: 2,
      binary: imageToByteListFloat32(image),
    );
  }

  Uint8List imageToByteListFloat32(im.Image image) {
    var convertedBytes = Float32List(64 * 64);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < 64; i++) {
      for (var j = 0; j < 64; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] =
            (im.getRed(pixel) + im.getGreen(pixel) + im.getBlue(pixel)) /
                3 /
                255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
