import 'package:tflite/tflite.dart';

class ModelRec {
  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/gender_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  void reco() async {
    var recognitions = await Tflite.runModelOnImage(
        path: 'assets/1.jpeg', // required
        numResults: 2, // defaults to 117.0
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5, // defaults to 0.1
        asynch: true // defaults to true
        );
    print(recognitions);
  }
}
