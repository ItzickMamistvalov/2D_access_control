clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 12;

% Define the possible color values in the colors code for future use
% After detecting code, we want to convert him the the original code
% Note detected code may contain deviation in values
red = 1 / 360; yellow = 60 / 360; green = 120 / 360 ;
cyan = 180 / 360; blue = 240 / 360; magenta = 300 / 360;
colorVector = [red yellow green cyan blue magenta];
colorVector = round(colorVector, 4);

% Reading scan directly from phone
rgbImage = imread('http://10.0.0.11:8080//photo.jpg'); % IP address should be modified
numOfFiles = 1;

% % Reading images from folder
% mainPath = pwd;
% folderPath = fullfile(mainPath, 'test images');
% imagePattern = fullfile(folderPath, '*.jpeg');
% imageFiles = dir(imagePattern);
% numOfFiles = length(imageFiles)

for k = 1 : numOfFiles
%     % If you read the image directly from phone, comment next 3 lines (you already have the rgbImage)
%     imageName = imageFiles(k).name;
%     imagePath = fullfile(folderPath, imageName);
%     rgbImage = imread(imagePath);

    % Display the original color image.
    figure(k);
    subplot(2, 2, 1);
    imshow(rgbImage);
    impixelinfo();
    title('Original Image', 'FontSize', fontSize);
    % Enlarge figure to full screen.
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);

    % convert to HSV format
    hsvImage = rgb2hsv(rgbImage);
    % Set hue values equal 1 to 0 (red)
    hueDim = hsvImage(:, :, 1);
    hueDim(find(hueDim > 0.95)) = 0;
    hsvImage(:, :, 1) = hueDim;
    figure(k);
    subplot(2, 2, 2);
    imshow(hsvImage);
    impixelinfo();
    title('HSV Image', 'FontSize', fontSize);
    
    % binarize the hsv image relative to Saturation & Value
    mask = (hsvImage(:, :, 3) > 0.8) & (hsvImage(:, :, 2) > 0.8) & (hsvImage(:, :, 1) < 1);
    figure(k);
    subplot(2, 3, 4);
    imshow(mask);
    impixelinfo();
    title('Initial Masked', 'FontSize', fontSize);

    SE = ones(32, 18);
    % Dilation followed by erosion = closing
    % Closing to fill small and thiny holes in the detected screen,
    % Which may be incompleted.
    morph_mask = imclose(mask, SE);

    figure(k);
    subplot(2, 3, 5);
    imshow(morph_mask);
    impixelinfo();
    title('Morphological closing', 'FontSize', fontSize);

    % Erase all connected components which are not part of the biggest blob
    labeled_mask = bwconncomp(morph_mask);
    numPixels = cellfun(@numel, labeled_mask.PixelIdxList);
    [biggest, idx] = max(numPixels);
    if isempty(idx)
        message = 'There is no proper mask';
        errordlg(message);
        return;
    end
    % Now we have the biggest blob in final_mask
    % Equate final_mask to zero, then apply the biggest blob.
    morph_mask(:, :) = 0;
    morph_mask(labeled_mask.PixelIdxList{idx}) = 1;

    final_mask = imfill(morph_mask, 'holes');

    % Mask aligment
    [straiten_final_mask, theta] = myImrotate4(final_mask);

    % getting the possible bounding boxes in the image 
    stats = regionprops(straiten_final_mask, 'BoundingBox');

    figure(k);
    subplot(2, 3, 6);
    imshow(straiten_final_mask);
    impixelinfo();
    title('Final mask', 'FontSize', fontSize);

    % displaying the bounding box on the image
    rectangle('Position', stats.BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2)

    % rotate the image according to the aligment angle
    rotatedRgbImage = imrotate(rgbImage, theta, 'crop');
    rotatedHsvImage = imrotate(hsvImage, theta, 'crop');

    % crop the image according to the bounding box of the aligment binary image
    % this should be the phone's screen
    croppedRgbColorCodeImage = imcrop(rotatedRgbImage, stats.BoundingBox);
    croppedHsvColorCodeImage = imcrop(rotatedHsvImage, stats.BoundingBox);

    % after cropping, separate each square to detect the code
    % first, create edged image of the hue chennel using imgradient()
    gradientHue = imgradient(croppedHsvColorCodeImage(:, :, 1));
    gradientHueMask = imbinarize(gradientHue, 0.05);
    gradientHueMask = ~gradientHueMask;
    % then, keep only the 15 biggest connected components 
    % they supposed to be the 15 squares which represent the code
    gradientHueMask = bwareafilt(gradientHueMask, 15, 'largest');
    gradientHueMask = imfill(gradientHueMask, 'holes');

    separatedHsvColorCodeImage = gradientHueMask .* croppedHsvColorCodeImage;

    figure(numOfFiles + k);
    subplot(2, 3, 1);
    imshow(croppedRgbColorCodeImage);
    impixelinfo();
    title("cropped RGB");
    subplot(2, 3, 2);
    imshow(croppedHsvColorCodeImage);
    impixelinfo();
    title("cropped HSV");
    subplot(2, 3, 3);
    imshow(separatedHsvColorCodeImage);
    impixelinfo();
    title("separated HSV");
    hold on;

    stats = regionprops(gradientHueMask, 'BoundingBox', 'Centroid', 'Area');

    % Get the size of the gradientHueMask image
    [m, n] = size(gradientHueMask);

    centroidPoints = zeros(15, 2);
    separatedHueChannelColorCodeImage = croppedHsvColorCodeImage(:, :, 1);
    detectedCode = [];
    [v, i] = maxk([stats.Area], 15);
    if length(i) ~= 15
        message = 'The barcode was not recognized correctly, please scan again';
        errordlg(message);
        return;
    end
    for ind = 1 : length(i)
        % check the ratio between the image's pixels area to each square
        % ideal ratio = 1 : 15, because there are 15 squares
        % allow ratio to be maximum 1 : 90 (each square is 6 times smaller)
    %     if stats(i(ind)).Area < (fix(m * n / 90)) || stats(i(ind)).Area > (fix(m * n / 15))
    %         message = 'The barcode was not recognized correctly, please scan again';
    %         errordlg(message);
    %         return;
    %     end
    %     rectangle('Position', stats(i(ind)).BoundingBox,...
    %     'EdgeColor','r', 'LineWidth', 2)
        centroidPoints(ind, :) =  stats(i(ind)).Centroid;
    end

    % Sorting the centroid points as code order
    sortedCentroidPoints = sortCentroidPoints(centroidPoints);

    for ind = 1 : length(i)
        rowPos = fix(sortedCentroidPoints(ind, 2));
        colPos = fix(sortedCentroidPoints(ind, 1));
        plot(colPos, rowPos, 'r.', 'MarkerSize', 10, 'LineWidth', 2);

        % The detected value of each square may be with error range
        % Set the value detected to the true origin value
        [minDiffValue, minDiffValueIndex] = min(abs(colorVector - ...
                                        separatedHueChannelColorCodeImage(rowPos, colPos)));                          
        if (minDiffValue <= 0.07)
            trueValue = colorVector(minDiffValueIndex);
            detectedCode(end + 1) = trueValue;
        else
            detectedCode(end + 1) = separatedHueChannelColorCodeImage(rowPos, colPos);
        end
    end

    detectedHash = DataHash(detectedCode);

    % Convert code to string for displaying as msgbox
    % String code rounded to 2 digits just for displaying issues
    strCode = mat2str(round(detectedCode, 2));

    % Check if the code exist in the hash matrix (approved/not approvevd)
    dataBase = load('hashMat.mat');
    codeMat = dataBase.hashMat;
    approved = checkExistence(detectedHash, codeMat);

    % Match the msgbox content up to approved
    [icon, message] = matchMsgBoxContent(approved);

    figure(numOfFiles + k);
    subplot(2, 1, 2);
    imshow(icon);
    title(message);

    % Create the msgbox
    createMsgBox(strCode, message, icon);
end
