% This function generating color code & color code image
% colorCode: 15 constant number code. each number represent color
% colorCodeImage: 1920x1080x3 image representing the color code
% Note that the image's values determined by HSV format 
function [colorCode, colorCodeImage, hashCode] = generateColorCode()
    % 6 possible hue values
    red = 1 / 360;
    yellow = 60 / 360;
    green = 120 / 360 ;
    cyan = 180 / 360; 
    blue = 240 / 360; 
    magenta = 300 / 360;
    
    % Defeine possible colors as array of values
    % Round values
    colorVector = [red yellow green cyan blue magenta];
    colorVector = round(colorVector, 4);
    
    % Define the color code Image
    colorCodeImage = ones(1920, 1080, 3);
    
    % Define the arrangement of the color code image
    % 5x3 color squares
    numOfRows = 5;
    numOfCols = 3;

    % Define isRepeted to check repetitions in the code
    % Initialized to 1 to enter first loop
    isRepeted = 1;
    
    while(isRepeted)
        % Define color code with 15 decimal fractions
        colorCode = colorVector([randperm(length(colorVector), 5) randperm(length(colorVector), 5) ...
            randperm(length(colorVector), 5)]); 
        isRepeted = checkRepetitions(colorCode);
    end
    
    % Create hash value for the code
    hashCode = DataHash(colorCode);
    
    % Define indexes for loop
    positionIndex = 1; rowIndex = 1; colIndex = 1; 
    shiftingRowConst = 384; shiftingColConst = 360;
    
    for i = 1 : numOfRows
        for j = 1 : numOfCols
            % Applying code value on hue dimension
            colorCodeImage(rowIndex : rowIndex + shiftingRowConst - 1, ...
                colIndex : colIndex + shiftingColConst - 1, 1) = colorCode(positionIndex);
            colIndex = colIndex + shiftingColConst;
            positionIndex = positionIndex + 1;
        end
        colIndex = 1;
        rowIndex = rowIndex + shiftingRowConst;
    end
end

