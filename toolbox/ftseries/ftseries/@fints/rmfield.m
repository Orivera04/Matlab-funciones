function t = rmfield(s, field)
%@FINTS/RMFIELD removes a field and its content from a FINTS object.
%
%   FTS = RMFIELD(FTS, FIELDNAME) removes the data series FIELDNAME and
%   its contents from the object FINTS.  FIELDNAME must be a cell array
%   if you would like to remove multiple data series from the object at
%   the same time.  It can be a string array of the data series name if 
%   ONE and only one series is to be removed from the object.
% 
%   Please note that the field names are case-sensitive.
%
%   See also GETFIELD, ISFIELD, FIELDNAMES, CHFIELD, RMFIELD.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $  $Date: 2002/01/21 12:21:14 $

% If the object is of an older version, convert it.
[fintsVersion, timeData] = fintsver(s);
if fintsVersion
    s = ftsold2new(s); % This sorts the fts too.
elseif ~issorted(s)
    s = sortfts(s);
end

% Check input argument(s).
if nargin ~= 2
    error('Ftseries:rmfield:SpecifySeriesNames2BRemoved', ...
        'Please specify series name(s) to be removed.');
end

if (~iscell(field) & ~isempty(field)) | (iscell(field) & ~cellfun('isempty', field))
    switch class(field)
    case 'char'
        if size(field, 1) ~= 1
            error('Ftseries:rmfield:UseCellArray', ...
                'To enter multiple names, use a cell array instead.');
        end
        nameidx = getnameidx(s.names, field);
        if nameidx == 0
            error('Ftseries:rmfield:SeriesNameNotInObject', ...
                'Data series name does not exist in the object.');
        elseif (nameidx < 4) | (nameidx == length(s.names))
            error('Ftseries:rmfield:DESC_FREQ_DATES_TIMESCannotBeRemoved', ...
                'Cannot remove DESC, FREQ, DATES, or TIMES.');
        end
    case 'cell'
        nameidx = getnameidx(s.names, field);
        if any(~nameidx)
            error('Ftseries:rmfield:SeriesNameNotInObject', ...
                'One or more data series names do not exist in the object.');
        elseif (nameidx < 4) | (nameidx == length(s.names))
            error('Ftseries:rmfield:DESC_FREQ_DATES_TIMESCannotBeRemoved', ...
                'Cannot remove DESC, FREQ, DATES, or TIMES.');
        end
    end
    
    if (s.serscount == 1) | (length(nameidx)==s.serscount)
        error('Ftseries:rmfield:CannotRemoveAllData', ...
            'It is invalid to remove all the data series in the object.');
    else
        s.names(nameidx) = [];
        s.data{4}(:, nameidx-3) = [];
        s.serscount = length(s.names) - 4;
        t = s;
    end
else
    t = s;
end

% [EOF]