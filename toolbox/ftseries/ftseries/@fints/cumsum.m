function fts = cumsum(ftsa)
% CUMSUM Overloaded for fints objects: cumulative sum of elements.
%
%   FTS = CUMSUM(FTSA) calculates the cumulative sum of each individual
%   time series data series in the FINTS object FTSA and returns the 
%   result in another object of the same class FTS.  FTS contains the 
%   same data series names as FTSA.
%
%   Example:   load disney
%              cs_dis = cumsum(fillts(dis));
%              plot(cs_dis);

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/04/14 16:31:12 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['CUMSUM of ', ftsa.data{1}]; % desc

fts.data{4} = [cumsum(ftsa.data{4}, 1)];    % data

% [EOF]
