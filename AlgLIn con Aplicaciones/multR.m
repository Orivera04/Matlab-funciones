function M = multR(k,M,r)
%multR  syntax: multR(constant,matrix,row)
%	row operation on the matrix that multiplies
%	every element of one row by a constant,
%	thereby replacing the row with new values

% Benjamin N. Levy, 1997

M(r,:) = k*M(r,:);
