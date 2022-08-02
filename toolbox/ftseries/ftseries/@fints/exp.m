function fts = exp(ftsa)
%@FINTS/EXP exponential of the values in a FINTS object.
%
%   NEWFTS = EXP(OLDFTS) calculates the exponential of all the data in 
%   the data series of the object OLDFTS and returns the result in 
%   another FINTS object NEWFTS.
%
%   See also @FINTS/LOG, @FINTS/LOG10.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/01/21 12:24:59 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['EXP of ', ftsa.data{1}];    % desc

fts.data{4} = [exp(ftsa.data{4})];          % data

% [EOF]