function szfts = size(fts, dim);
%@FINTS/SIZE Gets the number of dates and data series in a FINTS object.
%
%   SZFTS = SIZE(FTS) returns the number of dates (rows) and the number 
%   of data series (columns) in the FINTS object FTS.  The result is in 
%   the vector SZFTS whose first element is the number of dates and the 
%   second is the number of data series.
%
%   SZFTS = SIZE(FTS, DIM) allows you to specify which dimension you 
%   would like to get.  DIM = 1 returns the number of dates (rows) in 
%   the object while DIM = 2 returns the number of data series (columns).
%
%   See also SIZE, LENGTH, @FINTS/LENGTH.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/01/21 12:21:00 $

switch nargin
case 1
    szfts = [fts.datacount, fts.serscount];
case 2
    switch dim
    case 1
        szfts = fts.datacount;
    case 2
        szfts = fts.serscount;
    otherwise
        error('Ftseries:ftseries_fints_size:InvalidDimensionValue', ...
            'Valid dimension values are 1 and 2.');
    end
otherwise
    error('Ftseries:ftseries_fints_size:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% [EOF]