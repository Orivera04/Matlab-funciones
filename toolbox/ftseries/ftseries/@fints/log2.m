function fts = log10(ftsa)
%@FINTS/LOG2   Overloaded for FINTS object: Base 2 logarithm and dissect floating point number.
%
%   LOG2 calculates the log-base-2 of the data series in a financial 
%   time series object.  It returns another time series object that 
%   contains the resulting log-base-2 values.
%
%   NEWFTS = LOG2(OLDFTS) calculates the log-base-2 of all the data in 
%   the data series of the object OLDFTS and returns the result in the 
%   object NEWFTS.
%
%   See also @FINTS/EXP, @FINTS/LOG, @FINTS/LOG10.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.3 $   $Date: 2002/01/21 12:25:31 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['LOG2 of ', ftsa.data{1}];

fts.data{4} = [log2(ftsa.data{4})];

% [EOF]