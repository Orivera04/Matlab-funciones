function ftsmin = min(ftsa)
%@FINTS/MIN returns the minimum value of in a FINTS object component(s).
% 
%   TSMIN = MIN(FTS) will return the minimum value in each data series 
%   in the object FTS and return it in the structure TSMIN.  TSMIN is a 
%   structure with fieldname(s) identical to the data series name(s).
%
%   WARNING: It returns only the values and does not return the dates
%            associated with the values.  The minimum values are not
%            necessarily from the same date.
%
%   See also FINTS/MAX.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/01/21 12:22:33 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    w = warning('off');
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
    warning(w);
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

ftsmins = min(ftsa.data{4});

for idx = 4:length(ftsa.names)-1
    eval(['ftsmin.', ftsa.names{idx}, ' = ftsmins(idx-3);']);
end

% [EOF]