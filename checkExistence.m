% This function ensures that this is an exclusive code. 
% Each code should be unique.
% Input: hashCode: the hash code
%        hashMat: the matrix which contains the whole hash codes
% Output: isExistence: '1' = already exist, '0' = not exist
function [isExistence] = checkExistence(hashCode, hashMat)
    if nnz(ismember(hashMat, hashCode, 'rows'))
        isExistence = 1;
    else
        isExistence = 0;
    end
end