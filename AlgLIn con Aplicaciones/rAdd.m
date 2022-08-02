function M = rAdd(M,r1,r2)
%rAdd   syntax: rAdd(matrix,row1,row2)
%	row operation on the matrix that adds one row
%	to another row, thereby replacing the second row
%	with new values

% Benjamin N. Levy, 1997

M(r2,:) = M(r2,:) + M(r1,:);
