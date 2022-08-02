function sz = getTableSize(obj)
%GETTABLESIZE Return size of table
%
%  SZ = GETTABLESIZE(TBL) returns the size of the table.  SZ is a vector
%  the same length as the number of axes the table has.  The sizes are in
%  the same order as the inputs are defined, except for the first two which
%  are ordered [Ysize, Xsize, ...]
%
%  For example, for 1D tables SZ will be a scalar value.  For 2D tables SZ
%  will contain the values [Nrows, Ncols].  For higher dimensionality
%  tables, SZ will be [Nrows, Ncols, Npages_in_dim3, ...].
%
%  SEE ALSO: CGLOOKUP/GETNUMAXES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:19 $ 

sz = size(get(obj, 'values'));
Nax = getNumAxes(obj);
if Nax==1
    % Convert size to a scalar length
    sz = max(sz);
end