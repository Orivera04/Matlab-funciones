function M = mRAdd(k,M,r1,r2)
%mRAdd  syntax: mRAdd(constant,matrix,row1,row2)
%	row operation on the matrix that adds a constant
%	multiple of one row to another row, thereby
%	replacing the second row with new values

% Benjamin N. Levy, 1997

M(r2,:) = M(r2,:) + k*M(r1,:);
