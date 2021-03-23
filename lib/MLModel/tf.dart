import 'package:tflite/tflite.dart';

class ModelRec {
  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/gender_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<List> runModel() async {
    var recognitions = await Tflite.runModelOnImage(
        path: 'assets/2.jpeg', // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    print(recognitions);
  }
}
