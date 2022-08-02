function M = rSwap(M,r1,r2)
%rSwap  syntax: rSwap(matrix,row1,row2)
%	row operation on the matrix that interchanges
%	two rows

% Benjamin N. Levy, 1997

M([r1 r2],:) = M([r2 r1],:);
