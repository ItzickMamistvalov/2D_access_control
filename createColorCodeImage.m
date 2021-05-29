close all; clear all;

% Load hash matrix
% If not exist create and initialize first code as 'Initialize'
if exist('hashMat.mat', 'file')
    dataBase = load('hashMat.mat');
    hashMat = dataBase.hashMat;
else
    hashMat = (DataHash('Initialize'));
end

% Generate new color code & hash code
[colorCode, colorCodeImage, hashCode] = generateColorCode();
while checkExistence(hashCode, hashMat)
    [colorCode, colorCodeImage, hashCode] = generateColorCode();
end

% Insert the hash of the color code to the hash matrix
hashMat = [hashMat; hashCode];

% The color code image's values determined by HSV format
% Converting from HSV ro RGB for representation issues
rgbColorCodeImage = hsv2rgb(colorCodeImage);
fileName = sprintf('%s', hashCode);
fileName = strcat(fileName, '.png');
imagesFolder = 'C:\Users\itzic\Desktop\ASUS backup\4th year\IP\Project without PHP combined\Project\colorCodeImages';
fullFileName = fullfile(imagesFolder, fileName);
imwrite(rgbColorCodeImage, fullFileName);
figure('Name', 'Your Color Code Image', 'NumberTitle', 'off')
imshow(rgbColorCodeImage);

% Saving the hash code matrix
save('hashMat', 'hashMat');