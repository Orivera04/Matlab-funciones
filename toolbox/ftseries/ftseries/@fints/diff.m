function fts = diff(ftsa)
%@FINTS/DIFF calculates the difference of the values in a FINTS object.
%
%   DIFF calculates the difference of the data series in a financial 
%   time series object.  It returns another time series object that 
%   contains the difference.
%
%   NEWFTS = DIFF(OLDFTS) calculates the difference of all the data in 
%   the data series of the object OLDFTS and returns the result in the 
%   object NEWFTS.
%
%   See also DIFF.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:25:14 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = fints;

fts.names   = ftsa.names;

fts.data{1} = ['DIFF of ', ftsa.data{1}];   % desc
fts.data{2} = ftsa.data{2};                 % freq
fts.data{3} = ftsa.data{3}(2:end);          % dates
fts.data{4} = diff(ftsa.data{4});           % data
fts.data{5} = ftsa.data{5}(2:end);          % times

fts.datacount = ftsa.datacount - 1;
fts.serscount = ftsa.serscount;

% [EOF]