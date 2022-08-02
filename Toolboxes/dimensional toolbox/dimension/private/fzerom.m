function l = fzerom(M,dim)
% FZEROM find zero rows or columns in a matrix
%  L = FZEROM(M,DIM) find zero rows (DIM=2) or
%  zero columns (DIM=1) and returns a logical
%  index vetcor L with the index for zero rows

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-09

% check number of input arguments
msg = nargchk(1,2,nargin);
if msg
    error(msg);
    break;
end

% default value for dim if not given
if nargin == 1
    dim = 1;
end

s = sum(abs(M),dim);
f = find(s); 
l = ones(size(s)); l(f) = 0;
l = logical(l);
