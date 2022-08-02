function bounds = ftsbound(fts, dateform)
%@FINTS/FTSBOUND returns the starting and ending dates of a FINTS object.  
%
%   DATESBOUND = FTSBOUND(FTS) returns the starting and ending dates 
%   contained in the object, FTS, as serial dates in the column matrix, 
%   DATESBOUND.  The first element corresponds to the starting date and 
%   the second corresponds to the ending date.
%
%   If FTS contains time information, FTSBOUND is bounded by time and not
%   dates. This means that FTSBOUND will return the earliest time
%   chronologically of the starting date and the latest time 
%   chronologically of the ending date.
%
%   DATESBOUND = FTSBOUND(FTS, DATESTRFMT) returns the starting and 
%   ending dates and/or times contained in the object, FTS, as date strings
%   in the column matrix, DATESBOUND.  The first row corresponds to the
%   starting date and the second corresponds to the ending date. Please
%   refer to the help entry of DATESTR for the available date string formats.
%
%   See also DATESTR.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:24:15 $

% If the object is of an older version, convert it.
[fintsVersion,timeInfo] = fintsver(fts);
if fintsVersion
    w = warning('off');
    fts = ftsold2new(fts); % This sorts the fts too.
    warning(w);
elseif ~issorted(fts)
    fts = sortfts(fts);
end    

if timeInfo % There is time
    if nargin==1
        startdate = min(fts.data{3}+fts.data{5});
        enddate   = max(fts.data{3}+fts.data{5});
        bounds    = [startdate; enddate];
    elseif nargin==2
        if (dateform) < 0 | (dateform > 18)
            error('Ftseries:ftsbound:InvalidDatestrFormat', ...
                'Invalid DATESTR format. Please see ''help datestr''.');
        end
        
        startdate = datestr(min(fts.data{3}+fts.data{5}), dateform);
        enddate   = datestr(max(fts.data{3}+fts.data{5}), dateform);
        bounds    = [startdate; enddate];
    else
        error('Ftseries:ftsbound:InvalidNumInputs', ...
            'Invalid number of input arguments.');
    end
else    % There is no time
    if nargin==1
        startdate = min(fts.data{3});
        enddate   = max(fts.data{3});
        bounds    = [startdate; enddate];
    elseif nargin==2
        if (dateform < 0) | (dateform > 18)
            error('Ftseries:ftsbound:InvalidDatestrFormat', ...
                'Invalid DATESTR format. Please see ''help datestr''.');
        end
        
        startdate = datestr(min(fts.data{3}), dateform);
        enddate   = datestr(max(fts.data{3}), dateform);
        bounds    = [startdate; enddate];
    else
        error('Ftseries:ftsbound:InvalidNumInputs', ...
            'Invalid number of input arguments.');
    end
end

% [EOF]