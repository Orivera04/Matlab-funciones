function outsum = mymatsumb(mat)
% mymatsumb returns the overall sum of the elements
% in a matrix, with outer loop over columns
% Format: mymatsumb(matrix)

[row col] = size(mat);
outsum = 0;
 
% The outer loop is over the columns
for i = 1:col
    for j = 1:row
        outsum = outsum + mat(j,i);
    end
end
end
