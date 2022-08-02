function varargout = getDenormalizedBP(obj)
%GETDENORMALIZEDBP Return the denormalized breakpoints for the table cells
%
%  [AX1, AX2, ...] = GETDENORMALIZEDBP(OBJ) returns the real-world
%  breakpoint values for the table cells.  These are the values that are
%  equivalent to inverting (0:tablesize-1) through an axis' normalizer.
%
%  Note that 1D tables treat their first and only axis as the rows of a 1D
%  matrix.  Other tables treat their first axis as columns, second axis as
%  rows and 3rd and higher axes then correspond to the dimension order of a
%  MATLAB matrix.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:15 $ 

sz = getTableSize(obj);
pNorm = getinputs(obj);
ndims = getNumAxes(obj);

bpcell = cell(1, ndims);
for n = 1:ndims
    bpcell{n} = (0:sz(n)-1);
end
varargout = pvecinputeval(pNorm, @invert, bpcell);