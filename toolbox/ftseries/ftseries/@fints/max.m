function ftsmax = max(ftsa)
%@FINTS/MAX returns the maximum value of in a FINTS object component(s).
% 
%   TSMAX = MAX(FTS) will return the maximum value in each data series 
%   in the object FTS and return it in the structure TSMAX.  TSMAX is a 
%   structure with fieldname(s) identical to the data series name(s).
%
%   WARNING: It returns only the values and does not return the dates
%            associated with the values.  The maximum values are not
%            necessarily from the same date.
%
%   See also FINTS/MIN.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/01/21 12:22:48 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    w = warning('off');
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
    warning(w);
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

ftsmaxs = max(ftsa.data{4});

for idx = 4:length(ftsa.names)-1
    eval(['ftsmax.', ftsa.names{idx}, ' = ftsmaxs(idx-3);']);
end

% [EOF]