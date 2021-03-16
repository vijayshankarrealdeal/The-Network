import numpy as np
import tensorflow as tf
import cv2
import pathlib

# Load TFLite model and allocate tensors.
interpreter = tf.lite.Interpreter(model_path="assets/gender_model.tflite")


input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

interpreter.allocate_tensors()

print(input_details)
print(output_details)


    
img = cv2.imread(r'modelCheck/12.jpg')
new_img = cv2.resize(img, (64, 64))

new_img = new_img.astype('float32')
print(img)
print(new_img.dtype)
#input_details[0]['index'] = the index which accepts the input
interpreter.set_tensor(input_details[0]['index'], [new_img])
    
    # run the inference
interpreter.invoke()
    
    # output_details[0]['index'] = the index which provides the input
output_data = interpreter.get_tensor(output_details[0]['index'])
    
print("the output is {}".format(output_data))