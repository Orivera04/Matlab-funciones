function fts = log10(ftsa)
%@FINTS/LOG10 Overloaded for FINTS object: common logarithm (log base 10).
%
%   LOG10 calculates the common log of the data series in a financial 
%   time series object.  It returns another time series object that 
%   contains the common logs.
%
%   NEWFTS = LOG10(OLDFTS) calculates the common log of all the data in 
%   the data series of the object OLDFTS and returns the result in the 
%   object NEWFTS.
%
%   See also @FINTS/EXP, @FINTS/LOG, @FINTS/LOG2.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $   $Date: 2002/01/21 12:26:34 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['LOG10 of ', ftsa.data{1}];

fts.data{4} = [log10(ftsa.data{4})];

% [EOF]