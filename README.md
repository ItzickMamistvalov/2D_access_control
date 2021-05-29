# 2D_access_control
The project is written in Matlab and includes both generating colored barcodes and decoding them while scanning from a distance of 2 meters.
The colored barcode contains 15 colored squares, so there are six possible colors. The detection itself done using Matlab image processing toolbox functions (such as morphological, filtering, and thresholding operations) to locate the smartphone's screen and decipher the colored barcode displaying on it.

## Instructions + Explanation:
### Creation of a new colored barcode: 
Use 'createColorCodeImage.m' to create a new colored barcode. The barcode is a 1920x1080 pixel image, which contains 15 squares. The code is determined by their Hue's channel value of the square, concatenated to 15 long code. 

Run this function and get the image from the 'colorCodeImages' file. However, the image will be shown in a new figure. This is your colored barcode.

### Decoding colored barcode from an image: 
Use 'DetectingScreen.m' to decode the barcode, and determine whether or not he exists in the database. 

To test the algorithm's operation, choose one of two options: use the IP-Webcam app to scan the barcode directly from an external phone, or take a picture and read it from a file. for both options note that the brightness settings are at maximum level, and the barcode image covers the entire screen. Furthermore, the colors displayed in the colored code image must be clear as possible. Also, do not tilt the barcode image at too high angles.
1. For the app option, modify line 19 with the IP of your server (instead of 'Server's IP'. When running the script, the phone will be used as a scanner. Note for clear visibility, screen brightness, and distance. Put on comment lines 22-27 and 30-33.
1. For the file option, take an image in which the colored barcode is displayed on an external screen and load it to a file named 'test images'. Put on comment lines 18-20.

### The database: 
'hashMat.mat' contains all generated colored barcodes in their hash format. Instead of saving the codes and checking their existence in the database, there is a use in the 'DataHash.m' function. This function gets as an input any variable type and returns the output as a unique 32 long string. Therefore, after generating a new code, its hash values are saved, and after decoding the code, its hash value existence is checked.  

## Example for images. 
![WhatsApp Image 2021-05-25 at 16 04 55](https://user-images.githubusercontent.com/83509288/120078276-628eb580-c0b7-11eb-8205-b0da78c5a2f1.jpeg)
![WhatsApp Image 2021-05-25 at 11 59 18](https://user-images.githubusercontent.com/83509288/120078283-67536980-c0b7-11eb-9db2-f58243fdb27c.jpeg)
