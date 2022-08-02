function Y = blockdiag(varargin)
%BLOCKDIAG Block diagonal (constant or polynomial) matrix
%
%  BLOCKDIAG(A1,A2,...,An) returns a block diagonal matrix where the blocks
%  on the diagonal are constant (of type DOUBLE) matrices A1, A2, ..., An.
%  Both constant matrices (class DOUBLE) and polynomial matrices (class
%  POL) are accepted.
%
%  See also: DIAG, POL/DIAG

% Author(s): Z. Hurak   January 29, 2003

numRowsA = zeros(1,nargin);
numColsA = zeros(1,nargin);

ix = 1:nargin;

for ii = ix
    [numRowsA(ii),numColsA(ii)] = size(varargin{ii});
end

numRowsC = sum(numRowsA);
numColsC = sum(numColsA);

try,
    global PGLOBAL;
    PGLOBAL.FORMAT;
    C = pol(zeros(numRowsC,numColsC));
catch,
    C = zeros(numRowsC,numColsC);
end

startRowC = cumsum([1,numRowsA]);
startColC = cumsum([1,numColsA]);

for ii = ix
    C(startRowC(ii):startRowC(ii+1)-1,startColC(ii):startColC(ii+1)-1) = varargin{ii};
end

try,
    Y = double(C);
catch,
    Y = C;
end

    