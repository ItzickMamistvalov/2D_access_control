# 2D_access_control
The project is written in Matlab and includes both generating colored barcodes and decoding them while scanning from a distance of 2 meters.
The colored barcode contains 15 colored squares, so there are six possible colors. The detection itself done using Matlab image processing toolbox functions (such as morphological, filtering, and thresholding operations) to locate the smartphone's screen and decipher the colored barcode displaying on it.

To examine the operation of the project, take a picture of the cell phone while the barcode image is displayed on its screen. 
Note that the brightness settings are at maximum level, and the barcode image covers the entire screen. Furthermore, the colors displayed in the colored code image must be clear as possible. Also, do not tilt the barcode image at too high angles.

Creation of new colored barcode: 
Use 'createColorCodeImage.m' to create a new colored barcode. The barcode is a 1920x1080 pixel image, which contains 15 squares. The code is determined by their Hue's channel value of the square, concatenated to 15 long code. 

Decoding colored barcode from an image: 
Use 'DetectingScreen.m' to decode the barcode, and determine whether or not he exists in the database. 
To test the algorithm's operation, take a picture of a phone whose screen displaying

The database: 
'hashMat.m' contains all generated colored barcodes in their hash format. Instead of saving the codes and checking their existence in the database, there is a use in 'DataHash.m' function. This function gets as an input any variable type and returns the output as a unique 32 long string. Therefore, after generating a new code, its hash values are saved, and after decoding the code, its hash value existence is checked.  

