function ftsmean = mean(ftsa)
%@FINTS/MEAN returns the arithmetic average of a FINTS object component(s).
% 
%   TSMEAN = MEAN(FTS) will return the arithmetic mean of all the data of 
%   all of the series in the object FTS and return it in TSMEAN.  TSMEAN
%   is a structure with fieldname(s) identical to the data series name(s).
%
%   TSMEAN = MEAN(FTS(PERIODSTR)) will return the arithmetic mean of the 
%   data in the specified period PERIODSTR of all of the series in the 
%   object FTS and return it in TSMEAN.  PERIODSTR can be the normal 
%   MATLAB integer indices or the Financial Time Series date indices.
%
%   See also PERAVG, TSMOVAVG.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:22:43 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    w = warning('off');
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
    warning(w);
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

ftsmeans = mean(ftsa.data{4});

for idx = 4:length(ftsa.names)-1
   eval(['ftsmean.', ftsa.names{idx}, ' = ftsmeans(idx-3);']);
end

% [EOF]