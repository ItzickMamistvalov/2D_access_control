% This function ensures that there are no equal neighbors
% With regard to the matrix representation of the code (4 connected)
% Input: colorCode: the color code
% Output: isRepeted: '1' = there are repetitions, '0' = no repetitions.
function [isRepeted] = checkRepetitions(colorCode) 
    % Reshaping the code as 5x3 matrix
    codeAsMat = (reshape(colorCode, [3, 5]))';
    % Padding with zeros to check equality to neighbors
    tmpCodeMat = padarray(codeAsMat, [1 1], 0, 'both');
    [m, n] = size(tmpCodeMat);
    for i = 2 : m - 1
        for j = 2 : n - 1
            % right and left col
            if (tmpCodeMat(i, j) == tmpCodeMat(i, j + 1) ||...
                    tmpCodeMat(i, j) == tmpCodeMat(i, j -1))
                isRepeted = 1;
                break;
            % up and down row
            elseif (tmpCodeMat(i, j) == tmpCodeMat(i + 1, j) ||...
                    tmpCodeMat(i, j) == tmpCodeMat(i - 1, j))
                isRepeted = 1;
                break;
            else
                isRepeted = 0;
            end
        end
        if isRepeted
            break;
        end
    end
end



