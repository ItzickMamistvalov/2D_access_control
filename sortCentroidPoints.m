% This function sorting the centroid points
% Each centroid represents 1 color square of the color code image
% There is a need to sort them by their truly appearances in the code image
% centroidPoints: matrix in which each row is (x, y) location 
% sortedCentroidPoints: the sorted matrix
function [sortedCentroidPoints] = sortCentroidPoints(centroidPoints)
    % Firstly, sorting by height (rows)
    sortedCentroidPoints = sortrows(centroidPoints, 2); 
    % Secondly, sorting by width (columns)
    tmpInd = 1;
    for ind = 1 : 5 % sorting 5 groups (group for each row)
        sortedCentroidPoints(tmpInd : tmpInd + 2, :) = sortrows(sortedCentroidPoints(tmpInd : tmpInd + 2, :), 1);
        tmpInd = tmpInd + 3;
    end
end