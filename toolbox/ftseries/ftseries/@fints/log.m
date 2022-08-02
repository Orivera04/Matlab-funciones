function fts = log(ftsa)
%@FINTS/LOG Overloaded for FINTS object: natural logarithm (log base e).
%
%   LOG calculates the natural log of the data series in a financial 
%   time series object.  It returns another time series object that 
%   contains the natural logs.
%
%   NEWFTS = LOG(OLDFTS) calculates the natural log of all the data in 
%   the data series of the object OLDFTS and returns the result in the 
%   object NEWFTS.
%
%   See also @FINTS/EXP, @FINTS/LOG2, @FINTS/LOG10.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $   $Date: 2002/01/21 12:23:03 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['LOG of ', ftsa.data{1}];

fts.data{4} = [log(ftsa.data{4})];

% [EOF]