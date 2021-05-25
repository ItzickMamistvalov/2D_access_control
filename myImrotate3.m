% This function alignes binary image
% Input: image = binary image
% Output: straightenImage = the aligned binary image
%         theta = alignment angle
function [straightenImage, theta] = myImrotate3(image)
    % find all the corners in the binary image
    corenerPoints = detectHarrisFeatures(image);
    % sort the corners up to their row (in terms of graphs -  y value)
    sortedCorenerPoints = sortrows(corenerPoints.Location, 2);
    point1 = sortedCorenerPoints(1, :);
    point2 = sortedCorenerPoints(2, :);
    % calculate the incline
    m = (point2(2) - point1(2)) / (point2(1) - point1(1));
    % calculate the aligment angle
    theta = atan(m);
    % rotate the image
    straightenImage = imrotate(image, theta, 'crop');
end