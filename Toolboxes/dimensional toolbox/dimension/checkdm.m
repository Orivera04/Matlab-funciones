function b = checkdm(A,B)
%  CHECKDM check dimensional matrix for validity
%    b = CHECKDM(A,B) checks the dimensional matrix
%    formed by [B A] for validity and returns true (1)
%    if valid and false (0) if invalid
%    b = CHECKDM(D) checks the dimensional matrix
%    D for validity
%    The columns of the dimensional matrix correspond
%    to the variables, the rows to the dimensions

% Steffen Brueckner, 2002-02-09

% check number of input arguments
msg = nargchk(1,2,nargin);
if msg
    error(msg);
    break;
end

% check for empty matrices
if isequal(A,[]) | (nargin == 2 & isequal(B,[]))
    b = 0;
    break;
end

% form dimensional matrix if A,B inputs are given
if nargin == 2
    D = formdm([B A]);
else
    D = formdm(A);
end

% determine rank and size of D
r       = rank(D);
[rD,cD] = size(D);

% number of rows must correspond to the rank
if r == rD
    b = 1;
else
    b = 0;
end

% check if submatrix A is chosen appropriately
if nargin == 2
    rA = rank(A);
    if rA ~= r
        b = 0;
    end
end
    