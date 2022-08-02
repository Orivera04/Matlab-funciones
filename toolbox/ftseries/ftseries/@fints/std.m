function ftsstd = std(ftsa, flag)
%@FINTS/STD returns the standard deviation of FINTS object component(s).
% 
%   TSSTD = STD(FTS) will return the standard deviation of all the data 
%   of all of the series in the object FTS and return it in TSSTD.  
%   TSSTD is a structure with fieldname(s) identical to the data series 
%   name(s).
%
%   TSSTD = STD(FTS(PERIODSTR)) will return the standard deviation of 
%   the data in the specified period PERIODSTR of all of the series in 
%   the object FTS and return it in TSSTD.  PERIODSTR can be the normal 
%   MATLAB integer indices or the Financial Time Series date indices.
%
%   TSSTD = STD(FTS, FLAG) will return the standard deviation of all the 
%   data of all of the series in the object FTS and return it in TSSTD. 
%   The FLAG argument indicates the normalization factor; FLAG = 1 
%   normalizes the standard deviations by N (number of obervations or 
%   dates) and FLAG = 0 normalizes by (N-1).  TSSTD is a structure with 
%   fieldname(s) identical to the data series name(s).
%
%   See also FINTS/MEAN, FINTS/HIST.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/01/21 12:20:45 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

if nargin == 1
    ftsstds = std(ftsa.data{4});
elseif nargin == 2
    if flag ~= 0 & flag ~= 1
        error('Ftseries:ftseries_fints_std:InvalidFlag', ...
            'Valid FLAG''s are 0 or 1.');
    end
    ftsstds = std(ftsa.data{4}, flag);
end

for idx = 4:length(ftsa.names)-1
    eval(['ftsstd.', ftsa.names{idx}, ' = ftsstds(idx-3);']);
end

% [EOF]